# Copyright (c) 2022 Yahoo
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
    module Sheet
      # The sheets_service object used to create this sheet
      #
      # @example
      #   sheets_service = sheet.sheets_service
      #
      # @return [Google::Apis::SheetsV4::SheetsService]
      attr_reader :sheets_service

      # The spreadsheet object that contains this sheet
      #
      # @example
      #   spreadsheet = sheet.spreadsheet
      #
      # @return [Google::Apis::SheetsV4::Spreadsheet]
      attr_reader :spreadsheet
    end
  end
end
