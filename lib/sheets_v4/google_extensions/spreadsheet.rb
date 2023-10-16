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
    module Spreadsheet
      # The sheets_service object used to create this spreadsheet
      #
      # @example
      #   sheets_service = spreadsheet.sheets_service
      #
      # @return [Google::Apis::SheetsV4::SheetsService]
      attr_reader :sheets_service
    end
  end
end
