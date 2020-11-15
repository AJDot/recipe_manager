class CreateRecipeNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :recipes, :note, :text
  end
end
