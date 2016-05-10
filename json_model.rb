require 'json'

class JsonModel

  def self.parse_all(model)
    parsed_json[model]
  end

  def self.parse_single(model, id)
    parsed_json[model].select { |e| e['id'] = id }.first
  end

  private

  def self.parsed_json
    @memoized_parsed_json ||= JSON.parse(File.open('data.json').read)
  end
end