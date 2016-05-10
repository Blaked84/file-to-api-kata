require 'json_model'

class Movie < JsonModel

  MODEL_NAME = 'movies'


  def self.get(model_id)
    parse_single(MODEL_NAME, model_id)
  end

  def self.all
    parse_all(MODEL_NAME)
  end
end
