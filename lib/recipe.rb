require_relative 'category'
require_relative 'ethnicity'
require_relative 'step'
require_relative 'ingredient'
require_relative 'image'

class Recipe < ActiveRecord::Base
  has_and_belongs_to_many :categories, join_table: 'recipes_categories'
  has_and_belongs_to_many :ethnicities, join_table: 'recipes_ethnicities'
  has_many :steps, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  has_one :image, dependent: :destroy

  validates :name,
            uniqueness: {message: 'must be unique'},
            length: {minimum: 1, maximum: 100, message: 'must be between 1 and 100 characters'}
  validates :cook_time, with: :cook_time_validator

  def cook_time_validator
    hours, minutes = cook_interval.hours, cook_interval.minutes
    if [hours, minutes].any? { |duration| duration.empty? }
      errors[:cook_time] << 'entries must be 0 or greater.'
    elsif !(0..59).cover? minutes.to_i
      errors[:cook_time] << 'minutes must be between 0 and 59.'
    end
  end

  def cook_interval
    CookTime.new(cook_time)
  end
end
