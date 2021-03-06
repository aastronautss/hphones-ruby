# frozen_string_literal: true

require 'yaml'
require 'hashie/mash'

class Hphones
  ##
  # Stores information for endpoints.
  #
  class Endpoint
    class MissingParameterError < StandardError; end

    # The path to the endpoints file.
    ENDPOINTS_PATH = File.join(File.dirname(__FILE__), '..', '..', 'data', 'endpoints.yml')

    class << self
      def lookup(key)
        !endpoints[key.to_s].nil?
      end

      def endpoints
        @endpoints ||= load_endpoints_from_file
      end

      private

      def load_endpoints_from_file
        YAML.load_file ENDPOINTS_PATH
      end
    end

    def initialize(key, api, params = {})
      @key = key.to_s
      @api = api
      @params = Hashie::Mash.new params
    end

    def fetch
      api_params = compile_params
      req = Hphones::Request.new(api, self)
      req.send endpoint_info['method'], api_params
    end

    def response_type
      endpoint_info['response']
    end

    private

    attr_reader :key, :api, :params

    def endpoint_info
      @endpoint_info ||= self.class.endpoints[key]
    end

    def compile_params
      param_specs = endpoint_info['params']
      pairs = param_specs.map { |spec| compile_pair spec }
      Hash[pairs.compact]
    end

    def compile_pair(spec)
      spec['value'] ? default_pair_for(spec) : merged_pair_for(spec)
    end

    def default_pair_for(spec)
      [spec['key'], spec['value']]
    end

    def merged_pair_for(spec)
      key = spec['key']
      spec['required'] ? required_pair_for(key) : optional_pair_for(key)
    end

    def required_pair_for(key)
      params[key] ? [key, params[key]] : raise(MissingParameterError, "Parameter missing: #{key}")
    end

    def optional_pair_for(key)
      params[key] ? [key, params[key]] : nil
    end
  end
end
