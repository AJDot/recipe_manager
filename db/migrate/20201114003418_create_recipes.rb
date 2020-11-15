class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :name, limit: 100, null: false
      t.text :description
      t.interval :cook_time
      t.timestamps
    end
  end
end
