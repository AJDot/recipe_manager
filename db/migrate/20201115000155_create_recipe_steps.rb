class CreateRecipeSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.belongs_to :recipe
      t.text :description, null: false
      t.timestamps
    end
  end
end
