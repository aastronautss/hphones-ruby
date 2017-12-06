# frozen_string_literal: true

class Hphones
  ##
  # Represents an API request
  #
  class Request
    attr_reader :api

    def initialize(api)
      @api = api
    end

    def get(params = {})
      conn = api.connection
      Hphones::Response.new(conn.get(api.base_path, params))
    end
  end
end
