require 'carrierwave'

class RecipeImageUploader < CarrierWave::Uploader::Base
  storage :fog unless Sinatra::Application.test?

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end