# frozen_string_literal: true

require_relative 'sheets_v4/version'
require_relative 'sheets_v4/color'
require_relative 'sheets_v4/validate_api_object'

require 'google/apis/sheets_v4'
require 'json'
require 'logger'
require 'net/http'

# Unofficial helpers for the Google Sheets V4 API
#
# @api public
#
module SheetsV4
  # Validate the object using the named JSON schema
  #
  # The JSON schemas are loaded from the Google Disocvery API. The schemas names are
  # returned by `SheetsV4.api_object_schemas.keys`.
  #
  # @example
  #   schema_name = 'BatchUpdateSpreadsheetRequest'
  #   object = { 'requests' => [] }
  #   SheetsV4.validate_api_object(schema_name:, object:)
  #
  # @param schema_name [String] the name of the schema to validate against
  # @param object [Object] the object to validate
  # @param logger [Logger] the logger to use for logging error, info, and debug message
  #
  # @raise [RuntimeError] if the object does not conform to the schema
  #
  # @return [void]
  #
  def self.validate_api_object(schema_name:, object:, logger: Logger.new(nil))
    ValidateApiObject.new(logger).call(schema_name, object)
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

  # A mutex used to synchronize access to the schemas so they are only loaded once
  #
  # @return [Thread::Mutex]
  #
  # @api private
  #
  def self.schema_load_semaphore = @schema_load_semaphore

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

  # Given the name of the color, return a Google Sheets API color object
  #
  # Available color names are listed using `SheetsV4.color_names`.
  #
  # The object returned is frozen.  If you want a color you can change (for instance,
  # to adjust the `alpha` attribute), you must clone the object returned.
  #
  # @example
  #   SheetsV4::Color.color(:red) #=> { "red": 1.0, "green": 0.0, "blue": 0.0 }
  #
  # @param name [#to_sym] the name of the color requested
  #
  # @return [Hash] The color requested e.g. `{ "red": 1.0, "green": 0.0, "blue": 0.0 }`
  #
  # @api public
  #
  def self.color(name)
    SheetsV4::Color::COLORS[name.to_sym] || raise("Color #{name} not found")
  end

  # List the names of the colors available to use in the Google Sheets API
  #
  # @example
  #   SheetsV4::Color.color_names #=> [:black, :white, :red, :green, :blue, :yellow, :magenta, :cyan, ...]
  #
  # @return [Array<Symbol>] the names of the colors available
  # @api public
  #
  def self.color_names = SheetsV4::Color::COLORS.keys
end
