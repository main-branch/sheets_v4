# frozen_string_literal: true

# Copyright (c) 2022 Yahoo

require 'sheets_v4/google_extensions'

RSpec.describe SheetsV4::GoogleExtensions::SheetsService do
  let(:sheets_service_class) do
    Class.new do
      def get_spreadsheet(_spreadsheet_id)
        # Empty method because it doesn't matter to the test
      end
    end.prepend(described_class)
  end

  let(:spreadsheet_class) do
    Class.new do
      attr_reader :spreadsheet_id
      attr_reader :sheets

      def initialize(spreadsheet_id, sheets)
        @spreadsheet_id = spreadsheet_id
        @sheets = sheets
      end
    end
  end

  let(:sheet_class) do
    Class.new do
      def initialize(id, title)
        @properties = Struct.new(:id, :title).new(id, title)
      end
    end
  end

  let(:sheet1) { sheet_class.new(1, 'Sheet 1') }
  let(:sheet2) { sheet_class.new(2, 'Sheet 2') }
  let(:spreadsheet_id) { 'spreadsheet_id' }
  let(:spreadsheet) { spreadsheet_class.new(spreadsheet_id, [sheet1, sheet2]) }
  let(:sheets_service) { sheets_service_class.new }

  context 'when prepended to a class' do
    context 'when calling get_spreadsheet' do
      before do
        allow(sheets_service).to(
          receive(:original_get_spreadsheet).with(spreadsheet_id).and_return(spreadsheet)
        )
      end

      it 'should return the spreadsheet returned by calling original_get_spreadsheet ' do
        expect(sheets_service.get_spreadsheet(spreadsheet_id)).to eq(spreadsheet)
      end

      it 'should set the @sheets_service instance variable of the returned spreadsheet' do
        spreadsheet = sheets_service.get_spreadsheet(spreadsheet_id)
        expect(spreadsheet.instance_variable_get(:@sheets_service)).to eq(sheets_service)
      end

      it 'should set the @sheets_service and @spreadsheet instance varaibles of the returned sheets' do
        spreadsheet = sheets_service.get_spreadsheet(spreadsheet_id)
        spreadsheet.sheets.each do |sheet|
          expect(sheet.instance_variable_get(:@sheets_service)).to eq(sheets_service)
          expect(sheet.instance_variable_get(:@spreadsheet)).to eq(spreadsheet)
        end
      end
    end
  end
end
