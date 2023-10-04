# frozen_string_literal: true

module SheetsV4
  # Validate API Objects against the Google Discovery API
  #
  # @example
  #   logger = Logger.new(STDOUT, :level => Logger::ERROR)
  #   schema_name = 'batch_update_spreadsheet_request'
  #   object = { 'requests' => [] }
  #   SheetsV4::ApiObjectValidation::ValidateApiObject.new(logger:).call(schema_name:, object:)
  #
  # @api public
  #
  module ApiObjectValidation; end
end

require_relative 'api_object_validation/load_schemas'
require_relative 'api_object_validation/resolve_schema_ref'
require_relative 'api_object_validation/traverse_object_tree'
require_relative 'api_object_validation/validate_api_object'
