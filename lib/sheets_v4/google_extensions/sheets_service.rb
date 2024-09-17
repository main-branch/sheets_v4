# frozen_string_literal: true

module SheetsV4
  module GoogleExtensions
    # This module extends the `Google::Apis::SheetsV4::SheetsService` class to add
    # attributes to the `Google::Apis::SheetsV4::Spreadsheet` and `Google::Apis::SheetsV4::Sheet`
    # classes that reference the `SheetsService` instance used to retrieve them.
    #
    # Similarly, an attribute is added to the `Google::Apis::SheetsV4::Sheet` class
    # that references the `Google::Apis::SheetsV4::Spreadsheet` instance that contains it.
    #
    # This allows getting the `SheetsService` object from a spreadsheet or sheet object,
    # making it unnecessary to pass the `SheetsService` object around with the spreadsheet
    # and its sheets.
    #
    # @example
    #   require 'sheets_v4/google_extensions'
    #   sheets_service = SheetsV4::SheetsService.new
    #   spreadsheet = sheets_service.get_spreadsheet('1nT_q0TrQzC3dLZXuI3K9V5P3mArBVZpVd_vRsOpvcyk')
    #
    #   spreadsheet.sheets_service == sheets_service # => true
    #   spreadsheet.sheets.each do |sheet|
    #     sheet.sheets_service == sheets_service # => true
    #     sheet.spreadsheet == spreadsheet # => true
    #   end
    #
    # @api public
    #
    module SheetsService
      # Replace the prepending class's `get_spreadsheet` implementation
      #
      # When this module is prepended to a class, class's `get_spreadsheet` method
      # is replaced wity `new_get_spreadsheet` method from this module.  The class's
      # original `get_spreadsheet` method is renamed to `original_get_spreadsheet`.
      #
      # @example
      #   Google::Apis::SheetsV4::SheetsService.prepend(
      #     SheetsV4::GoogleExtensions::SheetsService
      #   )
      #
      # @return [void]
      #
      # @private
      #
      def self.prepended(prepended_to_class)
        prepended_to_class.send(:alias_method, :original_get_spreadsheet, :get_spreadsheet)
        prepended_to_class.send(:remove_method, :get_spreadsheet)
        prepended_to_class.send(:alias_method, :get_spreadsheet, :new_get_spreadsheet)
      end

      # @!method get_spreadsheet(spreadsheet_id, include_grid_data, ranges, fields, quota_user, options, &block)
      #
      #   @api public
      #
      #   Gets an existing spreadsheet
      #
      #   Creates a spreadsheet object by calling the original
      #   Google::Apis::SheetsV4::SheetsService#get_spreadsheet method and then does
      #   the following:
      #
      #   * Sets the `sheets_service` attribute for the returned spreadsheet.
      #   * Sets the `sheets_service` and `spreadsheet` attributes all the sheets contained in the spreadsheet.
      #
      #   See the documentation for Google::Apis::SheetsV4::SheetsService#get_spreadsheet for
      #   details on the parameters and return value.
      #
      #   @example Get a spreadsheet object and output new attributes:
      #     require 'sheets_v4'
      #     require 'sheets_v4/google_extensions'
      #
      #     sheets_service = SheetsV4::SheetsService.new
      #     spreadsheet_id = '1nT_q0TrQzC3dLZXuI3K9V5P3mArBVZpVd_vRsOpvcyk'
      #
      #     spreadsheet = sheets_service.get_spreadsheet(spreadsheet_id)
      #
      #   @return [Google::Apis::SheetsV4::Spreadsheet] the spreadsheet whose ID is `spreadsheet_id`

      # Replaces the `get_spreadsheet` method implementation in the prepended class
      #
      # @example
      #   spreadsheet = sheets_service.new_get_spreadsheet(spreadsheet_id)
      #
      # @private
      #
      # @return [Google::Apis::SheetsV4::Spreadsheet]
      #
      def new_get_spreadsheet(...)
        original_get_spreadsheet(...)&.tap do |spreadsheet|
          spreadsheet.instance_variable_set(:@sheets_service, self)
          spreadsheet.sheets.each do |sheet|
            sheet.instance_variable_set(:@sheets_service, self)
            sheet.instance_variable_set(:@spreadsheet, spreadsheet)
          end
        end
      end
    end
  end
end
