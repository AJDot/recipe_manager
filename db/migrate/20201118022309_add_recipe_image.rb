class AddRecipeImage < ActiveRecord::Migration[5.2]
  def up
    add_column :recipes, :image, :string
    drop_table :images, if_exists: true
  end

  def down
    remove_column :recipes, :image
  end
end
