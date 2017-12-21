# frozen_string_literal: true

class Hphones
  ##
  # Represents an API request
  #
  class Request
    attr_reader :api, :endpoint

    def initialize(api, endpoint)
      @api = api
      @endpoint = endpoint
    end

    def get(params = {})
      conn = api.connection
      compiled_params = params.merge('apikey' => api.api_key)
      Hphones::Response.new(self, conn.get(api.base_path, compiled_params))
    end

    def response_type
      endpoint.response_type
    end
  end
end
