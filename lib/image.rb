require_relative 'recipe_manager'

class Image < ActiveRecord::Base
  belongs_to :recipe

  attr_writer :tempfile_path

  after_save :save_image

  after_destroy :destroy_image

  def self.build(image_params)
    new_image = image_params[:filename]
    filename = new_image || params[:current_image]
    image = new(filename: filename)
    image.tempfile_path = image_params[:tempfile].path
    image
  end

  def file_path
    File.join(RecipeManager.data_path, 'images', recipe_filename)
  end

  def recipe_filename
    "#{recipe_base_name}#{ext_name}"
  end

  def recipe_base_name
    base_name = File.basename(filename, ext_name)
    "#{base_name}-#{recipe_id}"
  end

  private

  def save_image
    return if @tempfile_path.nil?

    FileUtils.copy(@tempfile_path, file_path)
    @tempfile = nil
  end

  def destroy_image
    FileUtils.rm(file_path)
  end

  def ext_name
    File.extname(filename)
  end
end
