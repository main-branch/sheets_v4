# frozen_string_literal: true

require 'active_support/inflector'
require 'json_schemer'

module SheetsV4
  module ValidateApiObjects
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
      #   validator = SheetsV4::ValidateApiObjects::Validator.new
      #
      # @param logger [Logger] the logger to use
      #
      def initialize(logger: Logger.new(nil))
        @logger = logger
      end

      # The logger to use internally
      #
      # Validation errors are logged at the error level. Other messages are logged
      # at the debug level.
      #
      # @example
      #   logger = Logger.new(STDOUT, :level => Logger::INFO)
      #   validator = SheetsV4::ValidateApiObjects::Validator.new(logger)
      #   validator.logger == logger # => true
      #   validator.logger.debug { "Debug message" }
      #
      # @return [Logger]
      #
      attr_reader :logger

      # Validate the object using the JSON schema named schema_name
      #
      # @example
      #   schema_name = 'batch_update_spreadsheet_request'
      #   object = { 'requests' => [] }
      #   validator = SheetsV4::ValidateApiObjects::Validator.new
      #   validator.call(schema_name:, object:)
      #
      # @param schema_name [String] the name of the schema to validate against
      # @param object [Object] the object to validate
      #
      # @raise [RuntimeError] if the object does not conform to the schema
      #
      # @return [void]
      #
      def call(schema_name:, object:)
        logger.debug { "Validating #{object} against #{schema_name}" }

        schema = { '$ref' => schema_name }
        schemer = JSONSchemer.schema(schema, ref_resolver:)
        errors = schemer.validate(object)
        raise_error!(schema_name, object, errors) if errors.any?

        logger.debug { "Object #{object} conforms to #{schema_name}" }
      end

      private

      # The resolver to use to resolve JSON schema references
      # @return [ResolveSchemaRef]
      # @api private
      def ref_resolver = @ref_resolver ||= SheetsV4::ValidateApiObjects::ResolveSchemaRef.new(logger:)

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
  end
end
