# frozen_string_literal: true

module SheetsV4
  # The Google extensions are additions directly to Google::Apis::SheetsV4 classes
  #
  # These additions are optional and provide convenience methods and attributes
  # that simplify use of the Google Sheets API.
  #
  # To use these extensions, require the `sheets_v4/google_extensions` file.
  #
  # @example
  #   require 'sheets_v4/google_extensions'
  #
  module GoogleExtensions; end
end

require_relative 'google_extensions/sheets_service'
require_relative 'google_extensions/spreadsheet'
require_relative 'google_extensions/sheet'

# @private
module Google
  module Apis
    # Add SheetsV4 extensions to Google::Apis::SheetsV4 classes
    module SheetsV4
      # Add SheetsV4 extensions to Google::Apis::SheetsV4::SheetsService
      class SheetsService
        prepend ::SheetsV4::GoogleExtensions::SheetsService
      end

      # Add SheetsV4 extensions to Google::Apis::SheetsV4::Spreadsheet
      class Spreadsheet
        prepend ::SheetsV4::GoogleExtensions::Spreadsheet
      end

      # Add SheetsV4 extensions to Google::Apis::SheetsV4::Sheet
      class Sheet
        prepend ::SheetsV4::GoogleExtensions::Sheet
      end
    end
  end
end
