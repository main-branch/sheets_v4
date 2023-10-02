# frozen_string_literal: true

module SheetsV4
  module ValidateApiObjects
    # Resolve a JSON schema reference to a Google Sheets API schema
    #
    # This class uses the Google Discovery API to get the schemas. Any schema reference
    # in the form `{ "$ref": "schema_name" }` will be resolved by looking up the schema
    # name in the Google Discovery API and returning the schema object (as a Hash).
    #
    # This means that `{ "$ref": "cell_data" }` is resolved by returning
    # `SheetsV4::ValidateApiObjects::LoadSchemas.new(logger:).call['cell_data']`.
    #
    # An RuntimeError is raised if `SheetsV4::ValidateApiObjects::LoadSchemas.new.call`
    # does not have a key matching the schema name.
    #
    # @example
    #   logger = Logger.new(STDOUT, level: Logger::INFO)
    #   ref_resolver = SheetsV4::ValidateApiObjects::ResolveSchemaRef.new(logger:)
    #   people_schema = { 'type' => 'array', 'items' => { '$ref' => 'person' } }
    #   json_validator = JSONSchemer.schema(people_schema, ref_resolver:)
    #   people_json = [{ 'name' => { 'first' => 'John', 'last' => 'Doe' } }]
    #
    #   # Trying to validate people_json using json_validator as follows:
    #
    #   json_validator.validate(people_json)
    #
    #   # will try to load the referenced schema for 'person'. json_validator will
    #   # do this by calling `ref_resolver.call(URI.parse('json-schemer://schema/person'))`
    #
    # @api private
    #
    class ResolveSchemaRef
      # Create a new schema resolver
      #
      # @param logger [Logger] the logger to use
      #
      # @api private
      #
      def initialize(logger: Logger.new(nil))
        @logger = logger
      end

      # The logger to use internally
      #
      # Currently, only debug messages are logged.
      #
      # @return [Logger]
      #
      # @api private
      #
      attr_reader :logger

      # Resolve a JSON schema reference
      #
      # @param ref [URI] the reference to resolve usually in the form "json-schemer://schema/{name}"
      #
      # @return [Hash] the schema object as a hash
      #
      # @api private
      #
      def call(ref)
        schema_name = ref.path[1..]
        logger.debug { "Reading schema #{schema_name}" }
        schemas = SheetsV4::ValidateApiObjects::LoadSchemas.new(logger:).call
        schemas[schema_name].tap do |schema_object|
          raise "Schema for #{ref} not found" unless schema_object
        end
      end
    end
  end
end
