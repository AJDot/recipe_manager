require 'pry'
require_relative 'cooktime'

class Recipe
  attr_reader :id, :name, :description, :cook_time, :ingredients, :categories,
              :ethnicities, :steps, :notes, :img_filename
  attr_writer :categories, :img_filename

  def initialize(data)
    @id = data[:recipe_id]
    @name = data[:name]
    @description = data[:description]
    @cook_time = CookTime.new(data[:cook_time])
    @ingredients = data[:ingredients]
    @categories = data[:categories]
    @ethnicities = data[:ethnicities]
    @steps = data[:steps]
    @notes = data[:notes]
    @img_filename = data[:img_filename]
  end

  def ==(other)
    @id == other.id
  end
end
