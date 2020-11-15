class CreateRecipesCategories < ActiveRecord::Migration[5.2]
  def change
    create_join_table :categories, :recipes, table_name: :recipes_categories do |t|
      t.index :category_id
      t.index :recipe_id
      t.timestamps
    end
  end
end
