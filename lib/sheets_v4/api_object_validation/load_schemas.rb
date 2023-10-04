# frozen_string_literal: true

module SheetsV4
  module ApiObjectValidation
    # Load the Google Discovery API description for the Sheets V4 API
    #
    # @example
    #   logger = Logger.new(STDOUT, :level => Logger::ERROR)
    #   schemas = SheetsV4::ApiObjectValidation::LoadSchemas.new(logger:).call
    #
    # @api private
    #
    class LoadSchemas
      # Loads schemas for the Sheets V4 API object from the Google Discovery API
      #
      # By default, a nil logger is used. This means that nothing is logged.
      #
      # The schemas are only loaded once and cached.
      #
      # @example
      #   schema_loader = SheetsV4::ApiObjectValidation::LoadSchemas.new
      #
      # @param logger [Logger] the logger to use
      #
      def initialize(logger: Logger.new(nil))
        @logger = logger
      end

      # The logger to use internally for logging errors
      #
      # @example
      #   logger = Logger.new(STDOUT, :level => Logger::INFO)
      #   schema_loader = SheetsV4::ApiObjectValidation::LoadSchemas.new(logger)
      #   schema_loader.logger == logger # => true
      #
      # @return [Logger]
      #
      attr_reader :logger

      # A hash of schemas keyed by the schema name loaded from the Google Discovery API
      #
      # @example
      #   SheetsV4.api_object_schemas #=> { 'PersonSchema' => { 'type' => 'object', ... } ... }
      #
      # @return [Hash<String, Object>] a hash of schemas keyed by schema name
      #
      def call
        self.class.schema_load_semaphore.synchronize { @call ||= load_api_object_schemas }
      end

      private

      # Validate
      # A mutex used to synchronize access to the schemas so they are only loaded
      # once.
      #
      @schema_load_semaphore = Thread::Mutex.new

      class << self
        # A mutex used to synchronize access to the schemas so they are only loaded once
        #
        # @return [Thread::Mutex]
        #
        # @api private
        #
        attr_reader :schema_load_semaphore
      end

      # Load the schemas from the Google Discovery API
      #
      # @return [Hash<String, Object>] a hash of schemas keyed by schema name
      #
      # @api private
      #
      def load_api_object_schemas
        source = 'https://sheets.googleapis.com/$discovery/rest?version=v4'
        http_response = Net::HTTP.get_response(URI.parse(source))
        raise_error(http_response) if http_response.code != '200'

        data = http_response.body
        JSON.parse(data)['schemas'].tap { |schemas| post_process_schemas(schemas) }
      end

      # Log an error and raise a RuntimeError based on the HTTP response code
      # @param http_response [Net::HTTPResponse] the HTTP response
      # @return [void]
      # @raise [RuntimeError]
      # @api private
      def raise_error(http_response)
        message = "HTTP Error '#{http_response.code}' loading schemas from '#{http_response.uri}'"
        logger.error(message)
        raise message
      end

      REF_KEY = '$ref'

      # A visitor for the schema object tree that fixes up the tree as it goes
      # @return [void]
      # @api private
      def schema_visitor(path:, object:)
        return unless object.is_a? Hash

        convert_schema_names_to_snake_case(path, object)
        convert_schema_ids_to_snake_case(path, object)
        add_unevaluated_properties(path, object)
        convert_property_names_to_snake_case(path, object)
        convert_ref_values_to_snake_case(path, object)
      end

      # Convert schema names to snake case
      # @return [void]
      # @api private
      def convert_schema_names_to_snake_case(path, object)
        object.transform_keys!(&:underscore) if path.empty?
      end

      # Convert schema IDs to snake case
      # @return [void]
      # @api private
      def convert_schema_ids_to_snake_case(path, object)
        object['id'] = object['id'].underscore if object.key?('id') && path.size == 1
      end

      # Add 'unevaluatedProperties: false' to all schemas
      # @return [void]
      # @api private
      def add_unevaluated_properties(path, object)
        object['unevaluatedProperties'] = false if path.size == 1
      end

      # Convert object property names to snake case
      # @return [void]
      # @api private
      def convert_property_names_to_snake_case(path, object)
        object.transform_keys!(&:underscore) if path[-1] == 'properties'
      end

      # Convert reference values to snake case
      # @return [void]
      # @api private
      def convert_ref_values_to_snake_case(_path, object)
        object[REF_KEY] = object[REF_KEY].underscore if object.key?(REF_KEY)
      end

      # Traverse the schema object tree and apply the schema visitor to each node
      # @return [void]
      # @api private
      def post_process_schemas(schemas)
        SheetsV4::ApiObjectValidation::TraverseObjectTree.call(
          object: schemas, visitor: ->(path:, object:) { schema_visitor(path:, object:) }
        )
      end
    end
  end
end
