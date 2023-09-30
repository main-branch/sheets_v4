# frozen_string_literal: true

require_relative 'sheets_v4/version'
require_relative 'sheets_v4/color'
require_relative 'sheets_v4/credential_creator'
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
  # Create a new Google::Apis::SheetsV4::SheetsService object
  #
  # Simplifies creating and configuring a the credential.
  #
  # @example using the crednetial in `~/.google-api-credential`
  #   SheetsV4.sheets_service
  #
  # @example using a credential passed in as a string
  #   credential_source = File.read(File.join(Dir.home, '.credential'))
  #   SheetsV4.sheets_service(credential_source:
  #
  # @param credential_source [nil, String, IO, Google::Auth::*] may
  #   be either an already constructed credential, the credential read into a String or
  #   an open file with the credential ready to be read. Passing `nil` will result
  #   in the credential being read from `~/.google-api-credential.json`.
  #
  # @param scopes [Object, Array] one or more scopes to access.
  #
  # @param credential_creator [#credential] Used to inject the credential creator for
  #   testing.
  #
  # @return a new SheetsService instance
  #
  def self.sheets_service(credential_source: nil, scopes: nil, credential_creator: SheetsV4::CredentialCreator)
    credential_source ||= File.read(File.expand_path('~/.google-api-credential.json'))
    scopes ||= [Google::Apis::SheetsV4::AUTH_SPREADSHEETS]

    Google::Apis::SheetsV4::SheetsService.new.tap do |service|
      service.authorization = credential_creator.call(credential_source, scopes)
    end
  end

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
