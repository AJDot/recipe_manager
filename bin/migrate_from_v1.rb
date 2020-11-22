require 'csv'

module NomNomNotes
  class MigrationV2
    def run
      backup_path = 'db/backups/v1/csv'
      get_csv = ->(filename) {
        CSV.read(File.join(Sinatra::Application.root, backup_path, filename))
      }
      csv_to_a = ->(headers, rows) {
        rows.reduce([]) do |agg, row|
          agg << headers.zip(row).to_h
        end
      }
      recipes_headers = [:id, :name, :description, :cook_time]
      recipes_csv = get_csv.call('recipes.csv')
      recipes_data = csv_to_a.call(recipes_headers, recipes_csv)

      categories_headers = [:id, :name]
      categories_csv = get_csv.call('categories.csv')
      categories_data = csv_to_a.call(categories_headers, categories_csv)

      recipes_categories_headers = [:recipe_id, :category_id]
      recipes_categories_csv = get_csv.call('recipes_categories.csv')
      recipes_categories_data = csv_to_a.call(recipes_categories_headers, recipes_categories_csv)

      ethnicities_headers = [:id, :name]
      ethnicities_csv = get_csv.call('ethnicities.csv')
      ethnicities_data = csv_to_a.call(ethnicities_headers, ethnicities_csv)

      recipes_ethnicities_headers = [:recipe_id, :ethnicity_id]
      recipes_ethnicities_csv = get_csv.call('recipes_ethnicities.csv')
      recipes_ethnicities_data = csv_to_a.call(recipes_ethnicities_headers, recipes_ethnicities_csv)

      ingredients_headers = [:recipe_id, :ing_number, :description, :complete]
      ingredients_csv = get_csv.call('ingredients.csv')
      ingredients_data = csv_to_a.call(ingredients_headers, ingredients_csv)

      steps_headers = [:recipe_id, :step_number, :description, :complete]
      steps_csv = get_csv.call('steps.csv')
      steps_data = csv_to_a.call(steps_headers, steps_csv)

      notes_headers = [:recipe_id, :note_number, :description]
      notes_csv = get_csv.call('notes.csv')
      notes_data = csv_to_a.call(notes_headers, notes_csv)

      images_headers = [:recipe_id, :img_number, :img_filename]
      images_csv = get_csv.call('images.csv')
      images_data = csv_to_a.call(images_headers, images_csv)

      # Move notes into recipes
      notes_data.group_by { |note| note[:recipe_id] }.each do |k, notes|
        joined_notes = notes.sort_by { |note| note[:note_number].to_i }.map { |note| note[:description] }.join("\r\n")
        rec = recipes_data.find { |x| x[:id] == k }
        rec[:note] = joined_notes
      end


      recipes = recipes_data.map do |rec|
        Recipe.find_or_create_by(rec)
      end

      categories = categories_data.map do |cat|
        Category.find_or_create_by(cat)
      end

      ethnicities = ethnicities_data.map do |cat|
        Ethnicity.find_or_create_by(cat)
      end

      recipes_categories_data.each do |rec_cat|
        Recipe.find(rec_cat[:recipe_id]).categories << categories.find { |x| x.id == rec_cat[:category_id].to_i }
      end

      recipes_ethnicities_data.each do |rec_eth|
        Recipe.find(rec_eth[:recipe_id]).ethnicities << ethnicities.find { |x| x.id == rec_eth[:ethnicity_id].to_i }
      end

      ingredients_data.group_by { |ingredient| ingredient[:recipe_id] }.each do |k, ingredients|
        ings = ingredients.sort_by { |ingredient| ingredient[:ing_number].to_i }
        rec = recipes.find { |x| x.id == k.to_i }
        rec.ingredients = ings.map { |x| Ingredient.new(x.slice(:recipe_id, :description)) }
      end

      steps_data.group_by { |step| step[:recipe_id] }.each do |k, steps|
        joined_steps = steps.sort_by { |step| step[:step_number].to_i }
        rec = recipes.find { |x| x.id == k.to_i }
        rec.steps = joined_steps.map { |x| Step.new(x.slice(:recipe_id, :description)) }
      end

      images_data.each do |data|
        rec = recipes.find { |x| x.id == data[:recipe_id].to_i }
        rec.image = Image.new(filename: data[:img_filename])
      end

      recipes.each(&:save)
    end
  end
end
