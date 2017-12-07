# frozen_string_literal: true

require 'json'
require 'hashie/mash'

class Hphones
  ##
  # Represents an API response
  #
  class Response
    def initialize(http_response)
      @http_response = http_response
    end

    def data
      @data ||= parse_json http_response.body
    end

    private

    attr_reader :http_response

    def parse_json(json_str)
      JSON.parse json_str
    end
  end
end
