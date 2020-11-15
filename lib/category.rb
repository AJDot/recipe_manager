class Category < ActiveRecord::Base
  has_and_belongs_to_many :recipes, join_table: 'recipes_categories'

  validates :name,
            uniqueness: {message: 'must be unique'},
            presence: true
end
