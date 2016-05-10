$LOAD_PATH << File.dirname(__FILE__)

require 'zlib'
require 'active_support'
require 'active_support/core_ext/object'

require 'rack/request'
require 'rack/response'

require 'movie'

module Rack
  class Eagle
    def call(env)
      req = Request.new(env)
      res = Response.new

      if req.get?
        model_name, model_id = res.write parse_url(req)
        if model_name == 'movies'
          if model_id.present?
            res.write "Getting one model with id #{model_id}\n"
            res.write Movie.get(model_id)
          else
            res.write "Getting all models\n"
            res.write Movie.all
          end
        else
          raise 'Error, dont know what to do with this model'
        end
      end

      res.write "hello world\n"

      res.write "\n"
      res.write rel_url(req)
      res.finish
      
    end

    def rel_url(req)
      req.url.gsub(req.base_url,"")
    end


    def parse_url(req)
      rel_url = rel_url(req)
      url_elements = rel_url[1..-1].split("/")
      case url_elements.count
      when 1
        [url_elements.first, nil]
      when 2
        url_elements
      else
        raise "Error, cannot parse this url #{rel_url}"
      end
    end
  end
end

if $0 == __FILE__
  require 'rack'
  # require 'rack/show_exceptions'
  Rack::Server.start(
    :app => Rack::ShowExceptions.new(Rack::Lint.new(Rack::Eagle.new)), :Port => 9292
    )
end