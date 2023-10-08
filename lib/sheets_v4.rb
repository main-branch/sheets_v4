# frozen_string_literal: true

require_relative 'sheets_v4/version'
require_relative 'sheets_v4/color'
require_relative 'sheets_v4/convert_dates_and_times'
require_relative 'sheets_v4/create_credential'
require_relative 'sheets_v4/api_object_validation'

require 'active_support'
require 'active_support/values/time_zone'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/string/zones'
require 'google/apis/sheets_v4'
require 'json'
require 'logger'
require 'net/http'

# Unofficial helpers for the Google Sheets V4 API
#
# @api public
#
module SheetsV4
  class << self
    # Create a new Google::Apis::SheetsV4::SheetsService object
    #
    # Simplifies creating and configuring a the credential.
    #
    # @example using the credential in `~/.google-api-credential`
    #   SheetsV4.sheets_service
    #
    # @example using a credential passed in as a string
    #   credential_source = File.read(File.expand_path('~/.google-api-credential.json'))
    #   SheetsV4.sheets_service(credential_source:)
    #
    # @example using a credential passed in as an IO
    #   credential_source = File.open(File.expand_path('~/.google-api-credential.json'))
    #   SheetsV4.sheets_service(credential_source:)
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
    def sheets_service(credential_source: nil, scopes: nil, credential_creator: SheetsV4::CreateCredential)
      credential_source ||= File.read(File.expand_path('~/.google-api-credential.json'))
      scopes ||= [Google::Apis::SheetsV4::AUTH_SPREADSHEETS]

      Google::Apis::SheetsV4::SheetsService.new.tap do |service|
        service.authorization = credential_creator.call(credential_source, scopes)
      end
    end

    # Validate the object using the named JSON schema
    #
    # The JSON schemas are loaded from the Google Disocvery API. The schemas names are
    # returned by `SheetsV4.api_object_schema_names`.
    #
    # @example
    #   schema_name = 'batch_update_spreadsheet_request'
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
    def validate_api_object(schema_name:, object:, logger: Logger.new(nil))
      SheetsV4::ApiObjectValidation::ValidateApiObject.new(logger:).call(schema_name:, object:)
    end

    # List the names of the schemas available to use in the Google Sheets API
    #
    # @example List the name of the schemas available
    #   SheetsV4.api_object_schema_names #=> ["add_banding_request", "add_banding_response", ...]
    #
    # @return [Array<String>] the names of the schemas available
    #
    def api_object_schema_names(logger: Logger.new(nil))
      SheetsV4::ApiObjectValidation::LoadSchemas.new(logger:).call.keys.sort
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
    def color(name)
      SheetsV4::Color::COLORS[name.to_sym] || raise("Color #{name} not found")
    end

    # List the names of the colors available to use in the Google Sheets API
    #
    # @example
    #   SheetsV4::Color.color_names #=> [:black, :white, :red, :green, :blue, :yellow, :magenta, :cyan, ...]
    #
    # @return [Array<Symbol>] the names of the colors available
    #
    def color_names = SheetsV4::Color::COLORS.keys

    # @!attribute [rw] default_spreadsheet_tz
    #
    # Set the default time zone for date and time conversions
    #
    # Valid time zone names are those listed in one of these two sources:
    # * `ActiveSupport::TimeZone.all.map { |tz| tz.tzinfo.name }`
    # * `ActiveSupport::TimeZone.all.map(&:name)`
    #
    # If you want to set the timezone to the time zone of the system's local time,
    # you could use the [timezone_local gem](https://rubygems.org/gems/timezone_local).
    #
    # @example
    #   SheetsV4.default_spreadsheet_tz = 'America/Los_Angeles'
    #
    # @example Set the time zone to the system's local time
    #   require 'timezone_local'
    #   SheetsV4.default_spreadsheet_tz = TimeZone::Local.get.name
    #
    # @return [void]
    #
    def default_spreadsheet_tz
      @default_spreadsheet_tz || raise('default_spreadsheet_tz not set')
    end

    def default_spreadsheet_tz=(time_zone)
      raise "Invalid time zone '#{time_zone}'" unless ActiveSupport::TimeZone.new(time_zone)

      @default_date_and_time_converter = nil unless @default_spreadsheet_tz == time_zone
      @default_spreadsheet_tz = time_zone
    end

    # The default converter for dates and times
    # @return [SheetsV4::ConvertDatesAndTimes]
    # @api private
    def default_date_and_time_converter
      @default_date_and_time_converter ||= SheetsV4::ConvertDatesAndTimes.new(default_spreadsheet_tz)
    end

    # Convert a Ruby Date object to a Google Sheet date value
    #
    # Uses the time zone given by `SheetsV4.default_spreadsheet_tz`.
    #
    # @example with a Date object
    #   SheetsV4.default_spreadsheet_tz = 'America/Los_Angeles'
    #   date = Date.parse('2021-05-17')
    #   SheetsV4.date_to_gs(date) #=> 44333
    #
    # @example with a DateTime object
    #   SheetsV4.default_spreadsheet_tz = 'America/Los_Angeles'
    #   date_time = DateTime.parse('2021-05-17 11:36:00 UTC')
    #   SheetsV4.date_to_gs(date_time) #=> 44333
    #
    # @param date [DateTime, Date, nil] the date to convert
    #
    # @return [Float, String] the value to sstore in a Google Sheet cell
    #   Returns a Float if date is not nil; otherwise, returns an empty string
    #
    def date_to_gs(date)
      default_date_and_time_converter.date_to_gs(date)
    end

    # Convert a Google Sheets date value to a Ruby Date object
    #
    # @example with a date value
    #   SheetsV4.default_spreadsheet_tz = 'America/Los_Angeles'
    #   gs_value = 44333
    #   SheetsV4.gs_to_date(gs_value) #=> #<Date: 2021-05-17 ...>
    #
    # @example with a date and time value
    #   SheetsV4.default_spreadsheet_tz = 'America/Los_Angeles'
    #   gs_value = 44333.191666666666
    #   SheetsV4.gs_to_date(gs_value) #=> #<Date: 2021-05-17 ...>
    #
    # @param gs_value [Float, "", nil] the value from the Google Sheets cell
    #
    # @return [Date, nil] the value represented by gs_date
    #
    #   Returns a Date object if a Float was given; otherwise, returns nil if an
    #   empty string or nil was given.
    #
    def gs_to_date(gs_value)
      default_date_and_time_converter.gs_to_date(gs_value)
    end

    # Convert a Ruby DateTime object to a Google Sheets value
    #
    # @example
    #   SheetsV4.default_spreadsheet_tz = 'America/Los_Angeles'
    #   date_time = DateTime.parse('2021-05-17 11:36:00 UTC')
    #   SheetsV4.datetime_to_gs(date_time) #=> 44333.191666666666
    #
    # @param datetime [DateTime, nil] the date and time to convert
    #
    # @return [Float, String] the value to store in a Google Sheet cell
    #   Returns a Float if datetime is not nil; otherwise, returns an empty string.
    #
    def datetime_to_gs(datetime)
      default_date_and_time_converter.datetime_to_gs(datetime)
    end

    # Convert a Google Sheets date time value to a DateTime object
    #
    # Time is rounded to the nearest second. The DateTime object returned is in
    # the time zone given by `SheetsV4.default_spreadsheet_tz`.
    #
    # @example
    #   SheetsV4.default_spreadsheet_tz = 'America/Los_Angeles'
    #   gs_value = 44333.191666666666
    #   SheetsV4.gs_to_datetime(gs_value) #=> #<DateTime: 2021-05-17T04:35:59-07:00 ...>
    #
    # @param gs_value [Float, "", nil] the value from the Google Sheets cell
    #
    # @return [DateTime, nil] the value represented by gs_datetime
    #   Returns a DateTime object if a Float was given; otherwise, returns nil if an
    #   empty string or nil was given.
    #
    def gs_to_datetime(gs_value)
      default_date_and_time_converter.gs_to_datetime(gs_value)
    end
  end
end
