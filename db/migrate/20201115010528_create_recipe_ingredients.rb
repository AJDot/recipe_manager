class CreateRecipeIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredients do |t|
      t.belongs_to :recipe
      t.text :description, null: false
    end
  end
end
