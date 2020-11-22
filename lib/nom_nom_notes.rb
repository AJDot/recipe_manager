module NomNomNotes
  extend self

  def data_path
    if ENV['RACK_ENV'] == 'test'
      File.expand_path("../../test/public/", __FILE__)
    else
      File.expand_path('../../public/', __FILE__)
    end
  end
end