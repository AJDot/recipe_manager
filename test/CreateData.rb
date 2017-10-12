module CreateData
  def create_recipe(storage, name, desc)
    # Insert recipe into database
    sql_insert_recipe = <<~SQL
      INSERT INTO recipes (name, description) VALUES
      ($1, $2)
    SQL
    storage.query(sql_insert_recipe, name, desc)
  end

  def get_recipe_id(storage, name, desc)
    sql = <<~SQL
      SELECT * FROM recipes
      WHERE name = $1
    SQL
    result = storage.query(sql, name)
    result[0]['id']
  end

  def create_category(storage, name)
    sql_insert_category = <<~SQL
      INSERT INTO categories (name) VALUES ($1)
    SQL
    @storage.query(sql_insert_category, name)
  end

  def get_category_id(storage, name)
    sql = <<~SQL
      SELECT * FROM categories
      WHERE name = $1
    SQL
    result = @storage.query(sql, name)
    result[0]['id']
  end
end
