# frozen_string_literal: true

module SheetsV4
  # Validate API Objects against the Google Discovery API
  #
  # @example
  #   logger = Logger.new(STDOUT, :level => Logger::ERROR)
  #   schema_name = 'batch_update_spreadsheet_request'
  #   object = { 'requests' => [] }
  #   SheetsV4::ValidateApiObjects::Validator.new(logger:).call(schema_name:, object:)
  #
  # @api public
  #
  module ValidateApiObjects; end
end

require_relative 'validate_api_objects/load_schemas'
require_relative 'validate_api_objects/resolve_schema_ref'
require_relative 'validate_api_objects/traverse_object_tree'
require_relative 'validate_api_objects/validate'
