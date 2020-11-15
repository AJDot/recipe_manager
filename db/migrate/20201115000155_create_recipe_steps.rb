class CreateRecipeSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.belongs_to :recipe
      t.string :description, limit: 100, null: false
      t.timestamps
    end
  end
end
