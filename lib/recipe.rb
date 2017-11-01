require 'pry'
require_relative 'cooktime'

class Recipe
  attr_reader :id, :name, :description, :cook_time, :ingredients,
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

  def ethnicities
    if block_given?
      @ethnicities.each { |eth| yield eth }
    else
      @ethnicities
    end
  end

  def categories
    if block_given?
      @categories.each { |cat| yield cat }
    else
      @categories
    end
  end

  def ingredients
    if block_given?
      @ingredients.each { |ing| yield ing }
    else
      @ingredients
    end
  end

  def steps
    if block_given?
      @steps.each { |step| yield step }
    else
      @steps
    end
  end

  def notes
    if block_given?
      @notes.each { |note| yield note }
    else
      @notes
    end
  end
end
