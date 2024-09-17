# frozen_string_literal: true

require 'google/apis/sheets_v4'
require 'googleauth'

module SheetsV4
  module GoogleExtensions
    # The SheetsService class implements handling credentials on top of the
    # Google::Apis::SheetsV4::SheetsService class.
    #
    # @api public
    #
    module Spreadsheet
      # The sheets_service object used to create this spreadsheet
      #
      # @example
      #   sheets_service = spreadsheet.sheets_service
      #
      # @return [Google::Apis::SheetsV4::SheetsService]
      attr_reader :sheets_service

      # Return the matching sheet object or nil
      #
      # If `id_or_title` is an Integer, it is assumed to be the sheet ID.  Otherwise,
      # it is assumed to be the sheet title.
      #
      # @example Get the sheet whose title is 'Sheet1'
      #   sheet = spreadsheet.sheet('Sheet1')
      #
      # @example Get the sheet whose title is '2023-03-15'
      #   date = Date.new(2023, 3, 15)
      #   sheet = spreadsheet.sheet(date)
      #
      # @example Get the sheet whose ID is 123456
      #   sheet = spreadsheet.sheet(123456)
      #
      # @param id_or_title [Integer, #to_s] the ID or title of the sheet to return
      #
      # @return [Google::Apis::SheetsV4::Sheet, nil]
      #
      def sheet(id_or_title)
        if id_or_title.is_a?(Integer)
          sheets.find { |sheet| sheet.properties.sheet_id == id_or_title }
        else
          title = id_or_title.to_s
          sheets.find { |sheet| sheet.properties.title == title }
        end
      end

      # Return the ID of the matching sheet
      #
      # @example
      #   id = spreadsheet.sheet_id('Sheet1')
      #
      # @param id_or_title [Integer, #to_s] the ID or title of the sheet
      #
      # @return [Integer]
      #
      def sheet_id(id_or_title)
        sheet(id_or_title)&.properties&.sheet_id
      end

      # Iterate over sheets in a spreadsheet
      #
      # If `ids_or_titles` is not given or is nil, all sheets are enumerated.  Otherwise,
      # only the sheets whose IDs or titles are in `sheets` are enumerated.
      #
      # @example Enumerate all sheets
      #   spreadsheet.each_sheet { |sheet| puts sheet.properties.title }
      #
      # @example Enumerate sheets whose IDs are 123456 and 789012
      #   sheets = [123456, 789012]
      #   spreadsheet.each_sheet(sheets).with_index do |sheet, index|
      #     puts "#{index}: #{sheet.properties.title} (#{sheet.properties.sheet_id})"
      #   end
      #
      # @param ids_or_titles [Array<Integer, #to_s>] an array of sheet IDs and/or titles
      #
      #   An Integer in this array is match to the sheet ID. Anything else is matched
      #   to the sheet title after calling `#to_s` on it.
      #
      # @return [void]
      #
      # @yield each matching sheet
      # @yieldparam [Google::Apis::SheetsV4::Sheet] the matching sheet
      #
      # @raise [RuntimeError] if one of the sheets does not exist
      # @raise [RuntimeError] if a block is not given
      #
      def each_sheet(ids_or_titles = sheets.map { |sheet| sheet.properties.sheet_id }, &block)
        return enum_for(:each_sheet, ids_or_titles) unless block

        matching_sheets = ids_or_titles.map do |id_or_title|
          sheet(id_or_title) || raise("Could not find sheet '#{id_or_title}'")
        end

        matching_sheets.each { |sheet| block[sheet] }

        self
      end
    end
  end
end
