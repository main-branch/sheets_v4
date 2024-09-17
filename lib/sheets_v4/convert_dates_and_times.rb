# frozen_string_literal: true

require 'active_support'
require 'active_support/values/time_zone'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/string/zones'

module SheetsV4
  # Convert between Ruby Date and DateTime objects and Google Sheets values
  #
  # Google Sheets uses decimal values to represent dates and times. These
  # conversion routines allows converting from Ruby Date and DateTime objects
  # and values that Google Sheets recognize.
  #
  # DateTime objects passed to `datetime_to_gs` or `date_to_gs` are converted to
  # the time zone of the spreadsheet given in the initializer. DateTime objects
  # returned by `gs_to_datetime` are always in the spreadsheet's time zone.
  #
  # Valid time zone names are those listed in one of these two sources:
  # * `ActiveSupport::TimeZone.all.map { |tz| tz.tzinfo.name }`
  # * `ActiveSupport::TimeZone.all.map(&:name)`
  #
  # @example
  #   tz = spreadsheet.properties.time_zone #=> e.g. 'America/Los_Angeles'
  #   converter = SheetsV4::ConvertDatesAndTimes.new(tz)
  #   date = Date.parse('1967-03-15')
  #   converter.date_to_gs(date) #=> 24546
  #   converter.gs_to_date(24546) #=> #<Date: 1967-03-15 ((2439565j,0s,0n),+0s,2299161j)>
  #
  #   date_time = DateTime.parse('2021-05-17 11:36:00 UTC')
  #   converter.datetime_to_gs(date_time) #=> 44333.191666666666
  #   converter.gs_to_datetime(44333.191666666666)
  #   #=> #<DateTime: 2021-05-17T11:36:00+00:00 ((2459352j,41760s,0n),+0s,2299161j)>
  #
  # @api public
  #
  class ConvertDatesAndTimes
    # The time zone passed into the initializer
    #
    # @example
    #   time_zone = 'UTC'
    #   converter = SheetsV4::ConvertDatesAndTimes.new(time_zone)
    #   converter.spreadsheet_tz
    #   #=> #<ActiveSupport::TimeZone:0x00007fe39000f908 @name="America/Los_Angeles", ...>
    #
    # @return [ActiveSupport::TimeZone] the time zone
    #
    attr_reader :spreadsheet_tz

    # Initialize the conversion routines for a spreadsheet
    #
    # @example
    #   time_zone = 'America/Los_Angeles'
    #   converter = SheetsV4::ConvertDatesAndTimes.new(time_zone)
    #
    # @param spreadsheet_tz [String] the time zone set in the spreadsheet properties
    #
    # @raise [RuntimeError] if the time zone is not valid
    #
    def initialize(spreadsheet_tz)
      @spreadsheet_tz = ActiveSupport::TimeZone.new(spreadsheet_tz)
      raise "Invalid time zone '#{spreadsheet_tz}'" unless @spreadsheet_tz
    end

    # Convert a Ruby DateTime object to a Google Sheets date time value
    #
    # @example
    #   time_zone = 'America/Los_Angeles'
    #   converter = SheetsV4::ConvertDatesAndTimes.new(time_zone)
    #   date_time = DateTime.parse('2021-05-17 11:36:00 UTC')
    #   converter.datetime_to_gs(date_time) #=> 44333.191666666666
    #
    # @param datetime [DateTime, nil] the date and time to convert
    #
    # @return [Float, String] the value to store in a Google Sheets cell
    #   Returns a Float if datetime is not nil; otherwise, returns an empty string.
    #
    def datetime_to_gs(datetime)
      return '' unless datetime

      time = datetime.to_time.in_time_zone(spreadsheet_tz)
      unix_to_gs_epoch(replace_time_zone(time, 'UTC').to_i)
    end

    # Convert a Google Sheets date time value to a DateTime object
    #
    # Time is rounded to the nearest second. The DateTime object returned is in
    # the spreadsheet's time zone given in the initiaizer.
    #
    # @example
    #   time_zone = 'America/Los_Angeles'
    #   converter = SheetsV4::ConvertDatesAndTimes.new(time_zone)
    #   gs_value = 44333.191666666666
    #   converter.gs_to_datetime(gs_value) #=> #<DateTime: 2021-05-17T04:35:59-07:00 ...>
    #
    # @param gs_datetime [Float, "", nil] the value from the Google Sheets cell
    #
    # @return [DateTime, nil] the value represented by gs_datetime
    #   Returns a DateTime object if a Float was given; otherwise, returns nil if an
    #   empty string or nil was given.
    #
    def gs_to_datetime(gs_datetime)
      return nil if gs_datetime.nil? || gs_datetime == ''

      raise 'gs_datetime is a string' if gs_datetime.is_a?(String)

      unix_epoch_datetime = gs_to_unix_epoch(gs_datetime.to_f)
      time = Time.at_without_coercion(unix_epoch_datetime, in: 'UTC')
      replace_time_zone(time, spreadsheet_tz).to_datetime
    end

    # Convert a Ruby Date object to a Google Sheets date value
    #
    # The Google Sheets date value is a float.
    #
    # @example with a Date object
    #   time_zone = 'America/Los_Angeles'
    #   converter = SheetsV4::ConvertDatesAndTimes.new(time_zone)
    #   date = Date.parse('2021-05-17')
    #   converter.date_to_gs(date) #=> 44333
    #
    # @example with a DateTime object
    #   time_zone = 'America/Los_Angeles'
    #   converter = SheetsV4::ConvertDatesAndTimes.new(time_zone)
    #   date_time = DateTime.parse('2021-05-17 11:36:00 UTC')
    #   converter.date_to_gs(date_time) #=> 44333
    #
    # @param date [DateTime, Date, nil] the date to convert
    #
    # @return [Float, String] the value to sstore in a Google Sheets cell
    #   Returns a Float if date is not nil; otherwise, returns an empty string
    #
    def date_to_gs(date)
      return datetime_to_gs(date).to_i if date.is_a?(DateTime)

      return (date - gs_epoch_start_date).to_i if date.is_a?(Date)

      ''
    end

    # Convert a Google Sheets date value to a Ruby Date object
    #
    # @example with a Date value
    #   time_zone = 'America/Los_Angeles'
    #   converter = SheetsV4::ConvertDatesAndTimes.new(time_zone)
    #   gs_value = 44333
    #   converter.gs_to_date(gs_value) #=> #<Date: 2021-05-17 ...>
    #
    # @example with a Date and Time value
    #   time_zone = 'America/Los_Angeles'
    #   converter = SheetsV4::ConvertDatesAndTimes.new(time_zone)
    #   gs_value = 44333.191666666666
    #   converter.gs_to_date(gs_value) #=> #<Date: 2021-05-17 ...>
    #
    # @param gs_date [Float, "", nil] the value from the Google Sheets cell
    #
    # @return [Date, nil] the value represented by gs_date
    #   Returns a Date object if a Float was given; otherwise, returns nil if an
    #   empty string or nil was given.
    #
    def gs_to_date(gs_date)
      return nil if gs_date.nil? || gs_date == ''

      raise 'gs_date is a string' if gs_date.is_a?(String)

      (gs_epoch_start_date + gs_date.to_i)
    end

    private

    # The Google Sheets epoch start Date to use when calculating dates
    # @return [Date] the 'zero' Date
    # @api private
    def gs_epoch_start_date
      @gs_epoch_start_date ||= Date.parse('1899-12-30')
    end

    # The number of seconds in a day
    #
    # @return [Integer] number of seconds in a day
    #
    SECONDS_PER_DAY = 86_400

    # The number of seconds between the Google Sheets Epoch and Unix Epoch
    #
    # Effectively the number of seconds between 1899-12-30 00:00:00 UTC and
    # 1970-01-01 00:00:00 UTC.
    #
    # @return [Integer] the number of seconds
    #
    SECONDS_BETWEEN_GS_AND_UNIX_EPOCHS = 25_569 * 86_400

    # Convert a gs_datetime to unix time
    #
    # @param gs_datetime [Float] time relative to the Google Sheets Epoch
    #
    # gs_datetime is a float representing the number of days since the start of
    # the Google Sheets epoch (1899-12-30 00:00:00 UTC).
    #
    # @return [Integer] the same datetime in Unix Time rounded to the nearest second
    #
    # Unix time is an integer representing the number of seconds since the start of
    # the Unix Epoch (1970-01-01 00:00:00 UTC). The number returned is rounded
    # to the nearest second.
    #
    # @api private
    #
    def gs_to_unix_epoch(gs_datetime)
      (gs_datetime * SECONDS_PER_DAY).round - SECONDS_BETWEEN_GS_AND_UNIX_EPOCHS
    end

    # Convert a unix time to gs_datetime
    #
    # @param unix_time [Integer] seconds since the Unix epoch 1970-01-01 00:00:00 UTC
    #
    # @return [Float] days since the Google Sheets epoch 1899-12-30 00:00:00 UTC
    #
    # @api private
    #
    def unix_to_gs_epoch(unix_time)
      (unix_time + SECONDS_BETWEEN_GS_AND_UNIX_EPOCHS).to_f / SECONDS_PER_DAY
    end

    # Given a time, change the time zone without impacting the displayed date/time
    #
    # @example
    #   replace_time_zone(Time.parse('2021-05-21 11:40 UTC'), 'America/Los_Angeles')
    #   #=> '2021-05-21 11:40 -0700'
    #
    # @param time [Time] the time object to adjust
    # @param time_zone_name [String] the desired time zone
    #
    # @return [Time] the resulting time object
    #
    # @api private
    #
    def replace_time_zone(time, time_zone_name)
      time.asctime.in_time_zone(time_zone_name)
    end
  end
end
