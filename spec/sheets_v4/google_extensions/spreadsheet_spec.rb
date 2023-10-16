# frozen_string_literal: true

# Copyright (c) 2022 Yahoo

require 'sheets_v4/google_extensions'

RSpec.describe SheetsV4::GoogleExtensions::Spreadsheet do
  let(:spreadsheet_class) do
    Class.new do
      attr_reader :spreadsheet_id
      attr_reader :sheets

      def initialize(spreadsheet_id, sheets)
        @spreadsheet_id = spreadsheet_id
        @sheets = sheets
      end

      prepend SheetsV4::GoogleExtensions::Spreadsheet
    end
  end

  let(:sheet_class) do
    Class.new do
      def initialize(id, title)
        @properties = Struct.new(:sheet_id, :title).new(id, title)
      end
      attr_reader :properties
    end
  end

  let(:sheet1) { sheet_class.new(1, 'Sheet1') }
  let(:sheet2) { sheet_class.new(2, 'Sheet2') }
  let(:sheets) { [sheet1, sheet2] }
  let(:spreadsheet_id) { 'spreadsheet_id' }
  let(:spreadsheet) { spreadsheet_class.new(spreadsheet_id, sheets) }

  describe '#sheet' do
    subject { spreadsheet.sheet(id_or_title) }

    context 'when the spreadsheet has one sheet whose id is 1 and title is "Sheet1"' do
      let(:sheets) { [sheet1] }

      context 'when requesting the sheet whose id is 1' do
        let(:id_or_title) { 1 }
        it 'should return the matching sheet' do
          expect(subject).to eq(sheet1)
        end
      end

      context 'when requesting the sheet whose title is "Sheet1"' do
        let(:id_or_title) { 'Sheet1' }
        it 'should return the matching sheet' do
          expect(subject).to eq(sheet1)
        end
      end

      context 'when requesting the sheet whose id is 2' do
        let(:id_or_title) { 2 }
        it 'should return nil' do
          expect(subject).to be_nil
        end
      end

      context 'when requesting the sheet whose title is "Sheet2"' do
        let(:id_or_title) { 'Sheet2' }
        it 'should return nil' do
          expect(subject).to be_nil
        end
      end
    end
  end

  describe '#sheet_id' do
    subject { spreadsheet.sheet_id(id_or_title) }

    context 'when the spreadsheet has one sheet whose id is 1 and title is "Sheet1"' do
      let(:sheets) { [sheet1] }

      context 'when requesting the sheet whose id is 1' do
        let(:id_or_title) { 1 }
        it 'should return the matching sheet' do
          expect(subject).to eq(1)
        end
      end

      context 'when requesting the sheet whose title is "Sheet1"' do
        let(:id_or_title) { 'Sheet1' }
        it 'should return the matching sheet' do
          expect(subject).to eq(1)
        end
      end

      context 'when requesting the sheet whose id is 2' do
        let(:id_or_title) { 2 }
        it 'should return nil' do
          expect(subject).to be_nil
        end
      end

      context 'when requesting the sheet whose title is "Sheet2"' do
        let(:id_or_title) { 'Sheet2' }
        it 'should return nil' do
          expect(subject).to be_nil
        end
      end
    end
  end

  describe '#each_sheet' do
    context 'when no sheets are given' do
      it 'should iterate over all sheets' do
        ids = []
        spreadsheet.each_sheet { |sheet| ids << sheet.properties.sheet_id }
        expect(ids).to eq([1, 2])
      end
    end

    context 'when sheets are given' do
      it 'should iterate over the matching sheets in the order given' do
        ids = []
        spreadsheet.each_sheet(%w[Sheet1 Sheet2]) { |sheet| ids << sheet.properties.sheet_id }
        expect(ids).to eq([1, 2])

        ids = []
        spreadsheet.each_sheet(%w[Sheet2 Sheet1]) { |sheet| ids << sheet.properties.sheet_id }
        expect(ids).to eq([2, 1])
      end
    end

    context 'when given a subset of sheets' do
      it 'should iterate over ONLY the matching sheets' do
        ids = []
        spreadsheet.each_sheet(%w[Sheet1]) { |sheet| ids << sheet.properties.sheet_id }
        expect(ids).to eq([1])
      end
    end

    context 'when given a sheet that does not exist' do
      it 'should raise a runtime error without calling the block' do
        ids = []
        begin
          spreadsheet.each_sheet(%w[Sheet1 Sheet3]) { |sheet| ids << sheet.properties.sheet_id }
        rescue RuntimeError
          runtime_error_raised = true
        end
        expect(runtime_error_raised).to eq(true)
        expect(ids).to eq([])
      end
    end

    context 'when given an empty array' do
      it 'should not call the block' do
        blocked_called = false
        spreadsheet.each_sheet(%w[]) { |_sheet| blocked_called = true }
        expect(blocked_called).to eq(false)
      end
    end

    context 'when called without a block' do
      it 'should return an Enumerator' do
        expect(spreadsheet.each_sheet).to be_kind_of(Enumerator)
      end

      it 'should allow calling other Enumerator functions like with_index' do
        result = []
        enumerator = spreadsheet.each_sheet
        enumerator.with_index do |sheet, index|
          result << [sheet.properties.title, index]
        end
        expect(result).to eq([['Sheet1', 0], ['Sheet2', 1]])
      end
    end
  end
end
