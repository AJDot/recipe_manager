class CreateEthnicities < ActiveRecord::Migration[5.2]
  def change
    create_table :ethnicities do |t|
      t.string :name, limit: 100, null: false
      t.timestamps
    end

    create_join_table :recipes, :ethnicities, table_name: :recipes_ethnicities do |t|
      t.index :ethnicity_id
      t.index :recipe_id
      t.timestamps
    end
  end
end
