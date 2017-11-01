require 'pg'
require 'yaml'

class DatabasePersistence
  def initialize(logger = nil)
    @db = if Sinatra::Base.production?
            PG.connect(ENV['DATABASE_URL'])
          elsif Sinatra::Base.test?
            PG.connect(dbname: 'recipe_manager_clean')
          else
            PG.connect(dbname: 'recipe_manager')
          end
    @logger = logger
  end

  def disconnect
    @db.close
  end

  def query(statement, *params)
    @logger.info "#{statement}: #{params}" if @logger

    # Quiet the numerous outputs from psql when testing
    @db.exec_params("SET client_min_messages = ERROR") if Sinatra::Base.test?

    @db.exec_params(statement, params)
  end

  def recipes
    sql = 'SELECT * FROM recipes'
    result = query(sql)
    result.map do |tuple|
      recipe_tuple_to_hash(tuple)
    end
  end

  def recipe(recipe_id)
    sql = 'SELECT * FROM recipes WHERE id = $1'
    result = query(sql, recipe_id)
    return if result.values.empty?
    recipe_tuple_to_hash(result[0])
  end

  def full_recipe(recipe_id)
    recipe = recipe(recipe_id)
    return unless recipe
    {
      id: recipe_id,
      name: recipe[:name],
      description: recipe[:description],
      cook_time: recipe[:cook_time],
      ingredients: recipe_ingredients(recipe_id),
      categories: recipe_categories(recipe_id),
      ethnicities: recipe_ethnicities(recipe_id),
      steps: recipe_steps(recipe_id),
      notes: recipe_notes(recipe_id),
      img_filename: recipe_image_filename(recipe_id)
    }
  end

  def create_recipe(data)
    return if recipe_exists?(data[:name])

    # if data[:description]
    #   sql_insert = 'INSERT INTO recipes (name, description) VALUES ($1, $2)'
    #   query(sql_insert, data[:name], data[:description])
    # else
      # sql_insert = 'INSERT INTO recipes (name) VALUES ($1)'
    sql_insert = <<~SQL
      INSERT INTO recipes (name, description, cook_time) VALUES
      ($1, $2, $3)
    SQL
    cook_time = hh_mm_to_cook_time(data[:hours], data[:minutes])
    query(sql_insert, data[:name], data[:description], cook_time)
    # end

    recipe_id = find_recipe_id(data[:name])

    # if data.key?(:categories)
      add_recipe_categories(recipe_id, *data[:categories])
    # end

    # if data.key?(:ethnicities)
      add_recipe_ethnicities(recipe_id, *data[:ethnicities])
    # end

    # if data[:ingredients] && !data[:ingredients].empty?
      add_recipe_ingredients(recipe_id, *data[:ingredients])
    # end

    # if data[:steps] && !data[:steps].empty?
      add_recipe_steps(recipe_id, *data[:steps])
    # end

    # if data[:notes] && !data[:notes].empty?
      add_recipe_notes(recipe_id, *data[:notes])
    # end

    # if data[:img_filename]
      update_recipe_image(recipe_id, data[:img_filename])
    # end
  end

  def update_recipe(recipe_id, data)
    sql_update = <<~SQL
      UPDATE recipes
         SET name = $2, description = $3, cook_time = $4
       WHERE id = $1
    SQL
    cook_time = hh_mm_to_cook_time(data[:hours], data[:minutes])
    query(sql_update, recipe_id, data[:name], data[:description], cook_time)
    update_recipe_categories(recipe_id, data[:categories])
    update_recipe_ethnicities(recipe_id, data[:ethnicities])
    update_recipe_ingredients(recipe_id, data[:ingredients])
    update_recipe_steps(recipe_id, data[:steps])
    update_recipe_notes(recipe_id, data[:notes])
  end

  def destroy_recipe(recipe_id)
    sql_delete = <<~SQL
      DELETE FROM recipes WHERE id = $1
    SQL

    query(sql_delete, recipe_id)
  end

  def find_recipe_id(recipe_name)
    sql = <<~SQL
      SELECT * FROM recipes
      WHERE name = $1
      LIMIT 1
    SQL

    query(sql, recipe_name)[0]['id'].to_i
  end

  # INGREDIENTS

  # FOR DATABASE VERSION 2
  ########################
  #
  def recipe_ingredients(recipe_id)
    sql = <<~SQL
      SELECT * FROM ingredients
      WHERE recipe_id = $1
    SQL

    result = query(sql, recipe_id)
    result.map do |tuple|
      ingredient_tuple_to_hash(tuple)
    end
  end

  def add_recipe_ingredients(recipe_id, *ings)
    return if ings.empty?
    sql = <<~SQL
      SELECT ing_number FROM ingredients
      WHERE recipe_id = $1
      ORDER BY ing_number DESC
      LIMIT 1
    SQL

    result = query(sql, recipe_id)
    next_number = result.ntuples + 1

    sql_insert = <<~SQL
      INSERT INTO ingredients
      (recipe_id, ing_number, description) VALUES
      #{sql_placeholders(ings.size, 3)}
    SQL

    ing_numbers = (next_number...(next_number + ings.size)).to_a
    nums_descriptions = ing_numbers.zip(ings)
    values = [recipe_id].product(nums_descriptions).flatten
    query(sql_insert, *values)
  end

  def destroy_recipe_ingredients(recipe_id)
    sql_delete = <<~SQL
      DELETE FROM ingredients
       WHERE recipe_id = $1
    SQL

    query(sql_delete, recipe_id)
  end

  def update_recipe_ingredients(recipe_id, ings)
    destroy_recipe_ingredients(recipe_id)
    add_recipe_ingredients(recipe_id, *ings)
  end

  def find_ingredient_id(ing_data)
    sql = <<~SQL
      SELECT * FROM ingredients
      WHERE description = $1
      LIMIT 1
    SQL

    query(sql, ing_data)[0]['id'].to_i
  end

  # CATEGORIES

  def recipe_categories(recipe_id = nil)
    sql = <<~SQL
      SELECT * FROM categories AS c
      INNER JOIN recipes_categories AS rc ON c.id = rc.category_id
      WHERE rc.recipe_id = $1
    SQL

    result = query(sql, recipe_id)
    result.map do |tuple|
      category_tuple_to_hash(tuple)
    end
  end

  def all_recipes_categories
    sql = <<~SQL
      SELECT * FROM categories AS c
      INNER JOIN recipes_categories AS rc ON c.id = rc.category_id
    SQL

    result = query(sql)
    result.map do |tuple|
      category_tuple_to_hash(tuple)
    end
  end

  def add_recipe_categories(recipe_id, *cat_names)
    # add category to database if it does not exist
    add_categories(*cat_names)

    cat_ids = cat_names.map { |cat_name| find_category_id(cat_name) }
    # reject if already associated with recipe
    cat_ids.reject! { |cat_id| recipe_category_exist?(recipe_id, cat_id) }

    # return if all categories are already associated with recipe
    return if cat_ids.empty?

    sql_insert = <<~SQL
      INSERT INTO recipes_categories (recipe_id, category_id) VALUES
      #{sql_placeholders(cat_ids.size, 2)}
    SQL

    values = [recipe_id].product(cat_ids).flatten

    query(sql_insert, *values)
  end

  def remove_recipe_category(recipe_id, cat_id)
    sql = <<~SQL
      DELETE FROM recipes_categories
      WHERE (recipe_id, category_id) = ($1, $2)
    SQL

    query(sql, recipe_id, cat_id)
  end

  def destroy_category(cat_id)
    return unless category_exists?(id: cat_id)
    query('DELETE FROM categories WHERE id = $1', cat_id)
  end

  def destroy_recipe_categories(recipe_id)
    sql_delete = <<~SQL
      DELETE FROM recipes_categories
       WHERE recipe_id = $1
    SQL

    query(sql_delete, recipe_id)
  end

  def update_recipe_categories(recipe_id, cats)
    destroy_recipe_categories(recipe_id)
    add_recipe_categories(recipe_id, *cats)
  end

  def find_category_id(cat_name)
    sql = <<~SQL
      SELECT * FROM categories
      WHERE name = $1
      LIMIT 1
    SQL

    query(sql, cat_name)[0]['id'].to_i
  end

  # ETHNICITIES

  def recipe_ethnicities(recipe_id)
    sql = <<~SQL
      SELECT * FROM ethnicities AS e
      INNER JOIN recipes_ethnicities AS re ON e.id = re.ethnicity_id
      WHERE re.recipe_id = $1
    SQL

    result = query(sql, recipe_id)
    result.map do |tuple|
      ethnicity_tuple_to_hash(tuple)
    end
  end

  def add_recipe_ethnicities(recipe_id, *eth_names)
    # add ethnicity to database if it does not exist
    add_ethnicities(*eth_names)

    eth_ids = eth_names.map { |eth_name| find_ethnicity_id(eth_name) }
    # reject if already associated with recipe
    eth_ids.reject! { |eth_id| recipe_ethnicity_exist?(recipe_id, eth_id) }

    # return if all ethnicities are already associated with recipe
    return if eth_ids.empty?

    sql_insert = <<~SQL
      INSERT INTO recipes_ethnicities (recipe_id, ethnicity_id) VALUES
      #{sql_placeholders(eth_ids.size, 2)}
    SQL

    values = [recipe_id].product(eth_ids).flatten

    query(sql_insert, *values)
  end

  def remove_recipe_ethnicity(recipe_id, eth_id)
    sql = <<~SQL
      DELETE FROM recipes_ethnicities
      WHERE (recipe_id, ethnicity_id) = ($1, $2)
    SQL

    query(sql, recipe_id, eth_id)
  end

  def destroy_ethnicity(eth_id)
    return unless ethnicity_exists?(id: eth_id)
    query('DELETE FROM ethnicities WHERE id = $1', eth_id)
  end

  def destroy_recipe_ethnicities(recipe_id)
    sql_delete = <<~SQL
      DELETE FROM recipes_ethnicities
       WHERE recipe_id = $1
    SQL

    query(sql_delete, recipe_id)
  end

  def update_recipe_ethnicities(recipe_id, eths)
    destroy_recipe_ethnicities(recipe_id)
    add_recipe_ethnicities(recipe_id, *eths)
  end

  def find_ethnicity_id(eth_name)
    sql = <<~SQL
      SELECT * FROM ethnicities
      WHERE name = $1
      LIMIT 1
    SQL

    query(sql, eth_name)[0]['id'].to_i
  end

  # STEPS

  def recipe_steps(recipe_id)
    sql = <<~SQL
      SELECT * FROM steps
      WHERE recipe_id = $1
    SQL

    result = query(sql, recipe_id)
    result.map do |tuple|
      step_tuple_to_hash(tuple)
    end
  end

  def add_recipe_steps(recipe_id, *steps)
    return if steps.empty?
    sql = <<~SQL
      SELECT step_number FROM steps
      WHERE recipe_id = $1
      ORDER BY step_number DESC
      LIMIT 1
    SQL

    result = query(sql, recipe_id)
    next_step_number = next_number(result)

    sql = <<~SQL
      INSERT INTO steps (recipe_id, step_number, description) VALUES
      #{sql_placeholders(steps.size, 3)}
    SQL

    step_numbers = (next_step_number...(next_step_number + steps.size)).to_a
    nums_descriptions = step_numbers.zip(steps)
    values = [recipe_id].product(nums_descriptions).flatten

    query(sql, *values)
  end

  def destroy_step(recipe_id, step_number)
    sql = <<~SQL
      DELETE FROM steps
      WHERE (recipe_id, step_number) = ($1, $2)
    SQL

    query(sql, recipe_id, step_number)
  end

  def destroy_recipe_steps(recipe_id)
    sql_delete = <<~SQL
      DELETE FROM steps
       WHERE recipe_id = $1
    SQL

    query(sql_delete, recipe_id)
  end

  def update_recipe_steps(recipe_id, steps)
    destroy_recipe_steps(recipe_id)
    add_recipe_steps(recipe_id, *steps)
  end

  # NOTES

  def recipe_notes(recipe_id)
    sql = <<~SQL
      SELECT * FROM notes
      WHERE recipe_id = $1
    SQL

    result = query(sql, recipe_id)
    result.map do |tuple|
      note_tuple_to_hash(tuple)
    end
  end

  def add_recipe_notes(recipe_id, *notes)
    return if notes.empty?
    sql = <<~SQL
      SELECT note_number FROM notes WHERE recipe_id = $1
      ORDER BY note_number DESC LIMIT 1
    SQL

    result = query(sql, recipe_id)
    next_note_number = next_number(result)

    sql_insert = <<~SQL
      INSERT INTO notes (recipe_id, note_number, description) VALUES
      #{sql_placeholders(notes.size, 3)}
    SQL

    note_numbers = (next_note_number...(next_note_number + notes.size)).to_a
    nums_descriptions = note_numbers.zip(notes)
    values = [recipe_id].product(nums_descriptions).flatten

    query(sql_insert, *values)
  end

  def destroy_note(recipe_id, note_number)
    sql = <<~SQL
      DELETE FROM notes
      WHERE (recipe_id, note_number) = ($1, $2)
    SQL

    query(sql, recipe_id, note_number)
  end

  def destroy_recipe_notes(recipe_id)
    sql_delete = <<~SQL
      DELETE FROM notes
       WHERE recipe_id = $1
    SQL

    query(sql_delete, recipe_id)
  end

  def update_recipe_notes(recipe_id, notes)
    destroy_recipe_notes(recipe_id)
    add_recipe_notes(recipe_id, *notes)
  end

  # IMAGES

  def recipe_image_filename(recipe_id)
    sql = <<~SQL
      SELECT * FROM images
      WHERE recipe_id = $1
      LIMIT 1
    SQL

    result = query(sql, recipe_id)

    return if result.values.empty?

    result[0]["img_filename"]
  end

  def all_images
    sql = <<~SQL
      SELECT * FROM images
    SQL

    result = query(sql)
    result.map do |tuple|
      image_tuple_to_hash(tuple)
    end
  end

  def update_recipe_image(recipe_id, filename)
    return unless filename
    sql = <<~SQL
      SELECT img_filename FROM images WHERE recipe_id = $1
      ORDER BY img_number DESC LIMIT 1
    SQL

    result = query(sql, recipe_id)
    if result.values.empty?
      add_recipe_image(recipe_id, filename)
    else
      modify_recipe_image(recipe_id, filename)
    end
  end

  def add_recipe_image(recipe_id, filename)
    sql_insert = <<~SQL
      INSERT INTO images (recipe_id, img_number, img_filename) VALUES
        ($1, $2, $3)
    SQL
    query(sql_insert, recipe_id, 1, filename)
  end

  def modify_recipe_image(recipe_id, filename)
    sql_update = <<~SQL
      UPDATE images
      SET img_filename = $1
      WHERE recipe_id = $2
    SQL

    query(sql_update, filename, recipe_id)
  end


  # GENERAL

  def yaml_to_database(*paths)
    paths.each do |path|
      data = YAML.load_file(path)
      new_recipe = {
        name: data[:title],
        description: data[:description],
        categories: data[:categories].reject { |cat| ['None', 'none'].include? cat },
        ethnicities: data[:ethnicities].reject { |eth| ['None', 'none'].include? eth },
        ingredients: data[:ingredients].map do |ing|
          "#{ing[:amount]} #{ing[:unit]} #{ing[:name]}"
        end,
        steps: data[:directions].map do |dir|
          dir[:direction]
        end,
        notes: data[:notes].reject { |notes| ['None', 'none'].include? notes }
      }
      create_recipe(new_recipe)
    end
  end

  ######################################################

  private

  ######################################################

  # RECIPES

  def recipe_exists?(recipe_name)
    sql = <<~SQL
      SELECT * FROM recipes
      WHERE name = $1
      LIMIT 1
    SQL

    !query(sql, recipe_name).ntuples.zero?
  end

  def recipe_tuple_to_hash(tuple)
    {
      recipe_id: tuple['id'].to_i,
      name: tuple['name'],
      description: tuple['description'],
      cook_time: tuple['cook_time']
    }
  end

  # INGREDIENTS

  # def ingredient_exists?(options = {})
  #   if options[:id]
  #     property = @db.quote_ident('id')
  #     value = options[:id]
  #   elsif options[:name]
  #     property = @db.quote_ident('name')
  #     value = options[:name]
  #   end
  #
  #   sql = <<~SQL
  #     SELECT * FROM ingredients
  #     WHERE #{property} = $1
  #     LIMIT 1
  #   SQL
  #
  #   !query(sql, value).ntuples.zero?
  # end
  #
  # def find_ingredient_id(ing_name)
  #   sql = <<~SQL
  #     SELECT * FROM ingredients
  #     WHERE name = $1
  #     LIMIT 1
  #   SQL
  #
  #   query(sql, ing_name)[0]['id'].to_i
  # end
  #
  # def recipe_ingredient_exist?(recipe_id, ing_id)
  #   sql = <<~SQL
  #     SELECT * FROM recipes_ingredients
  #     WHERE (recipe_id, ingredient_id) = ($1, $2)
  #   SQL
  #   !query(sql, recipe_id, ing_id).ntuples.zero?
  # end
  #
  # def add_ingredients(*ing_names)
  #   ing_names.reject! { |ing_name| ingredient_exists?(name: ing_name) }
  #   return if ing_names.empty?
  #
  #   sql = <<~SQL
  #     INSERT INTO ingredients (name) VALUES
  #     #{sql_placeholders(ing_names.size, 1)}
  #   SQL
  #
  #   query(sql, *ing_names)
  # end

  def ingredient_tuple_to_hash(tuple)
    {
      recipe_id: tuple['recipe_id'].to_i,
      ing_number: tuple['ing_number'].to_i,
      description: tuple['description'],
      complete: tuple['complete'] == 't'
    }
  end

  # CATEGORIES

  def category_exists?(options = {})
    if options[:id]
      property = @db.quote_ident('id')
      value = options[:id]
    elsif options[:name]
      property = @db.quote_ident('name')
      value = options[:name]
    end

    sql = <<~SQL
      SELECT * FROM categories
      WHERE #{property} = $1
      LIMIT 1
    SQL

    !query(sql, value).ntuples.zero?
  end

  def recipe_category_exist?(recipe_id, cat_id)
    sql = <<~SQL
      SELECT * FROM recipes_categories
      WHERE (recipe_id, category_id) = ($1, $2)
    SQL
    !query(sql, recipe_id, cat_id).ntuples.zero?
  end

  def add_categories(*cat_names)
    cat_names.reject! { |cat_name| category_exists?(name: cat_name) }
    return if cat_names.empty?

    sql = <<~SQL
      INSERT INTO categories (name) VALUES
      #{sql_placeholders(cat_names.size, 1)}
    SQL

    query(sql, *cat_names)
  end

  def category_tuple_to_hash(tuple)
    {
      recipe_id: tuple['recipe_id'].to_i,
      category_id: tuple['category_id'].to_i,
      name: tuple['name']
    }
  end

  # ETHNICITIES

  def ethnicity_exists?(options = {})
    if options[:id]
      property = @db.quote_ident('id')
      value = options[:id]
    elsif options[:name]
      property = @db.quote_ident('name')
      value = options[:name]
    end

    sql = <<~SQL
      SELECT * FROM ethnicities
      WHERE #{property} = $1
      LIMIT 1
    SQL

    !query(sql, value).ntuples.zero?
  end

  def recipe_ethnicity_exist?(recipe_id, eth_id)
    # Detect with SQL
    sql = <<~SQL
      SELECT * FROM recipes_ethnicities
      WHERE (recipe_id, ethnicity_id) = ($1, $2)
    SQL
    !query(sql, recipe_id, eth_id).ntuples.zero?

    # Detect with Ruby
    # ethnicities(recipe_id).any? do |eth|
    #   eth[:recipe_id] == recipe_id && eth[:ethnicity_id] == eth_id
    # end
  end

  def add_ethnicities(*eth_names)
    eth_names.reject! { |eth_name| ethnicity_exists?(name: eth_name) }
    return if eth_names.empty?

    sql = <<~SQL
      INSERT INTO ethnicities (name) VALUES
      #{sql_placeholders(eth_names.size, 1)}
    SQL

    query(sql, *eth_names)
  end

  def ethnicity_tuple_to_hash(tuple)
    {
      recipe_id: tuple['recipe_id'].to_i,
      ethnicity_id: tuple['ethnicity_id'].to_i,
      name: tuple['name']
    }
  end

  # STEPS

  def step_tuple_to_hash(tuple)
    {
      recipe_id: tuple['recipe_id'].to_i,
      step_number: tuple['step_number'].to_i,
      description: tuple['description'],
      complete: tuple['complete'] == 't'
    }
  end

  # NOTES

  def note_tuple_to_hash(tuple)
    {
      recipe_id: tuple['recipe_id'].to_i,
      note_number: tuple['note_number'].to_i,
      description: tuple['description']
    }
  end

  # IMAGES

  def image_tuple_to_hash(tuple)
    {
      recipe_id: tuple['recipe_id'].to_i,
      img_number: tuple['img_number'].to_i,
      img_filename: tuple['img_filename']
    }
  end

  # GENERAL

  def next_number(result)
    result.ntuples.zero? ? 1 : result.getvalue(0, 0).to_i + 1
  end

  def sql_placeholders(group_count, number_per_group)
    Array.new(group_count) do |n|
      values = '('

      values << Array.new(number_per_group) do |i|
        "$#{number_per_group * n + i + 1}"
      end.join(', ')

      values << ')'
    end.join(', ')
  end

  def hh_mm_to_cook_time(hours, minutes)
    hours = hours || '0'
    minutes = minutes || '0'
    hours + ':' + minutes
  end
end
