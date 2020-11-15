class CreateRecipeImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.belongs_to :recipe
      t.text :filename, null: false
    end
  end
end
