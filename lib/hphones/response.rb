# frozen_string_literal: true

require 'json'
require 'hashie/mash'

class Hphones
  ##
  # Represents an API response
  #
  class Response
    STATUS_OK = 'OK'

    RESPONSE_TYPE_JSON = 'json'
    RESPONSE_TYPE_STATUS = 'status'
    RESPONSE_TYPE_PATH = 'path'

    def initialize(request, http_response)
      @http_response = http_response
      @request = request
    end

    def data
      @data ||= parse_data http_response.body
    end

    private

    attr_reader :request, :http_response

    def parse_data(body)
      case request.response_type
      when RESPONSE_TYPE_JSON
        parse_json body
      when RESPONSE_TYPE_STATUS
        parse_status body
      when RESPONSE_TYPE_PATH
        parse_path body
      end
    end

    def parse_json(body)
      JSON.parse body
    end

    def parse_status(body)
      case body
      when STATUS_OK
        true
      else
        false
      end
    end

    def parse_path(body)
      body
    end
  end
end
