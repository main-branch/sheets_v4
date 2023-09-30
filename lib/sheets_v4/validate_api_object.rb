# frozen_string_literal: true

require 'json_schemer'

module SheetsV4
  # Validate objects against a Google Sheets API request object schema
  #
  # @api public
  #
  class ValidateApiObject
    # Create a new validator
    #
    # By default, a nil logger is used. This means that no messages are logged.
    #
    # @example
    #   logger = Logger.new(STDOUT, :level => Logger::INFO)
    #   validator = SheetsV4::ValidateApiObject.new(logger)
    #
    # @param logger [Logger] the logger to use
    #
    def initialize(logger = Logger.new(nil))
      @logger = logger
    end

    # The logger to use internally
    #
    # Validation errors are logged at the error level. Other messages are logged
    # at the debug level.
    #
    # @example
    #   logger = Logger.new(STDOUT, :level => Logger::INFO)
    #   validator = SheetsV4::ValidateApiObject.new(logger)
    #   validator.logger == logger # => true
    #   validator.logger.debug { "Debug message" }
    #
    # @return [Logger]
    #
    attr_reader :logger

    # Validate the object using the JSON schema named schema_name
    #
    # @example
    #   schema_name = 'BatchUpdateSpreadsheetRequest'
    #   object = { 'requests' => [] }
    #   validator = SheetsV4::ValidateApiObject.new
    #   validator.call(schema_name, object)
    #
    # @param schema_name [String] the name of the schema to validate against
    # @param object [Object] the object to validate
    #
    # @raise [RuntimeError] if the object does not conform to the schema
    #
    # @return [void]
    #
    def call(schema_name, object)
      logger.debug { "Validating #{object} against #{schema_name}" }

      schema = { '$ref' => schema_name }
      schemer = JSONSchemer.schema(schema, ref_resolver:)
      errors = schemer.validate(object)
      raise_error!(schema_name, object, errors) if errors.any?

      logger.debug { "Object #{object} conforms to #{schema_name}" }
    end

    private

    # The resolver to use to resolve JSON schema references
    # @return [SchemaRefResolver]
    # @api private
    def ref_resolver = @ref_resolver ||= SchemaRefResolver.new(logger)

    # Raise an error when the object does not conform to the schema
    # @return [void]
    # @raise [RuntimeError]
    # @api private
    def raise_error!(schema_name, object, errors)
      error = errors.first['error']
      error_message = "Object #{object} does not conform to #{schema_name}: #{error}"
      logger.error(error_message)
      raise error_message
    end
  end

  # Resolve JSON schema references to Google Sheets API schemas
  #
  # Uses the Google Discovery API to get the schemas. This is an implementation
  # detail used to interact with JSONSchemer.
  #
  # @api private
  #
  class SchemaRefResolver
    # Create a new schema resolver
    #
    # @param logger [Logger] the logger to use
    #
    # @api private
    #
    def initialize(logger)
      @logger = logger
    end

    # The logger to use internally
    #
    # Currently, only info messages are logged.
    #
    # @return [Logger]
    #
    # @api private
    #
    attr_reader :logger

    # Resolve a JSON schema reference
    #
    # @param ref [String] the reference to resolve usually in the form "#/definitions/schema_name"
    #
    # @return [Hash] the schema object as a hash
    #
    # @api private
    #
    def call(ref)
      schema_name = ref.path[1..]
      logger.debug { "Reading schema #{schema_name}" }
      schema_object = self.class.api_object_schemas[schema_name]
      raise "Schema for #{ref} not found" unless schema_object

      schema_object.to_h.tap do |schema|
        schema['unevaluatedProperties'] = false
      end
    end

    # A hash of schemas keyed by the schema name loaded from the Google Discovery API
    #
    # @example
    #   SheetsV4.api_object_schemas #=> { 'PersonSchema' => { 'type' => 'object', ... } ... }
    #
    # @return [Hash<String, Object>] a hash of schemas keyed by schema name
    #
    def self.api_object_schemas
      schema_load_semaphore.synchronize { @api_object_schemas ||= load_api_object_schemas }
    end

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
    def self.load_api_object_schemas
      source = 'https://sheets.googleapis.com/$discovery/rest?version=v4'
      resp = Net::HTTP.get_response(URI.parse(source))
      data = resp.body
      JSON.parse(data)['schemas'].tap do |schemas|
        schemas.each { |_name, schema| schema['unevaluatedProperties'] = false }
      end
    end
  end
end
