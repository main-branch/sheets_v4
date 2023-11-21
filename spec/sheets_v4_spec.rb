# frozen_string_literal: true

require 'logger'
require 'net/http'

RSpec.describe SheetsV4 do
  it 'has a version number' do
    expect(SheetsV4::VERSION).not_to be nil
  end

  describe '.sheets_service' do
    subject { described_class.sheets_service(credential_source:, scopes:, credential_creator:) }
    let(:credential_source) { double('credential_source') }
    let(:scopes) { double('scopes') }
    let(:credential_creator) { double('credential_creator') }
    let(:credential) { double('credential') }
    let(:expected_result) { double('expected_result') }

    before do
      allow(Google::Apis::SheetsV4::SheetsService).to receive(:new).and_return(expected_result)

      expect(expected_result).to receive(:authorization=).with(credential)

      allow(credential_creator).to(
        receive(:call)
        .with(credential_source, scopes)
        .and_return(credential)
      )
    end

    it 'should create a new Google::Apis::SheetsV4::SheetsService' do
      expect(subject).to eq(expected_result)
    end

    context 'when credential_source is nil' do
      let(:credential_source) { nil }
      it 'should read the credential from ~/.google-api-credential.json' do
        expect(File).to receive(:read).with(File.expand_path('~/.google-api-credential.json'))
        expect(subject).to eq(expected_result)
      end
    end

    context 'when scopes is nil' do
      let(:scopes) { nil }
      let(:expected_default_scopes) { [Google::Apis::SheetsV4::AUTH_SPREADSHEETS] }

      it 'should use the default scopes' do
        expect(credential_creator).to(
          receive(:call)
          .with(credential_source, expected_default_scopes)
          .and_return(credential)
        )
        expect(subject).to eq(expected_result)
      end
    end
  end

  describe '.color' do
    it 'should return the color object for the given name' do
      SheetsV4::Color::COLORS.each_key do |color_name|
        expect(described_class.color(color_name)).to eq(SheetsV4::Color::COLORS[color_name])
      end
    end

    it 'should return the color object when name is given as a symbol' do
      expect(described_class.color(:black)).to eq(SheetsV4::Color::COLORS[:black])
    end

    it 'should return the color object when name is given as a string' do
      expect(described_class.color('black')).to eq(SheetsV4::Color::COLORS[:black])
    end

    it 'should raise a RuntimeError if a color is not found' do
      expect { described_class.color(:non_existant_color) }.to raise_error(RuntimeError)
    end
  end

  describe '.default_spreadsheet_tz' do
    subject { described_class.default_spreadsheet_tz }
    context 'when a default is not set' do
      it 'shoud raise a RuntimeError' do
        expect { subject }.to raise_error(RuntimeError)
      end
    end

    context 'when the default is set' do
      before do
        described_class.default_spreadsheet_tz = 'America/Los_Angeles'
      end
      it { is_expected.to eq('America/Los_Angeles') }
    end
  end

  describe '.default_spreadsheet_tz=' do
    subject { described_class.default_spreadsheet_tz = value }
    context 'when value is a valid time zone' do
      let(:value) { 'America/Los_Angeles' }
      it 'should set the default time zone' do
        subject
        expect(described_class.default_spreadsheet_tz).to eq(value)
      end
    end
    context 'when value is not a valid time zone' do
      let(:value) { 'invalid time zone' }
      it 'should raise a RuntimeError' do
        expect { subject }.to raise_error(RuntimeError)
      end
    end
  end

  describe '.default_date_and_time_converter' do
    subject { described_class.default_date_and_time_converter }
    let(:default_spreadsheet_tz) { double('default_spreadsheet_tz') }
    let(:converter) { double('converter') }

    before do
      allow(SheetsV4).to receive(:default_spreadsheet_tz).and_return(default_spreadsheet_tz)
      allow(SheetsV4::ConvertDatesAndTimes).to(
        receive(:new)
        .with(default_spreadsheet_tz)
        .and_return(converter)
      )
    end

    after do
      SheetsV4.instance_variable_set(:@default_date_and_time_converter, nil)
    end

    it 'should create a new SheetsV4::ConvertDatesAndTimes' do
      expect(subject).to eq(converter)
    end
  end

  describe '.date_to_gs' do
    subject { described_class.date_to_gs(date) }
    let(:date) { double('date') }
    let(:expected_result) { double('expected_result') }
    let(:converter) { double('converter') }

    before do
      allow(SheetsV4).to(receive(:default_date_and_time_converter).and_return(converter))
      allow(converter).to receive(:date_to_gs).with(date).and_return(expected_result)
    end

    it 'should call SheetsV4::ConvertDatesAndTimes#date_to_gs' do
      expect(subject).to eq(expected_result)
    end
  end

  describe '.gs_to_date' do
    subject { described_class.gs_to_date(gs_date) }
    let(:gs_date) { double('gs_date') }
    let(:expected_result) { double('expected_result') }
    let(:converter) { double('converter') }

    before do
      allow(SheetsV4).to(receive(:default_date_and_time_converter).and_return(converter))
      allow(converter).to receive(:gs_to_date).with(gs_date).and_return(expected_result)
    end

    it 'should call SheetsV4::ConvertDatesAndTimes#gs_to_date' do
      expect(subject).to eq(expected_result)
    end
  end

  describe '.datetime_to_gs' do
    subject { described_class.datetime_to_gs(datetime) }
    let(:datetime) { double('datetime') }
    let(:expected_result) { double('expected_result') }
    let(:converter) { double('converter') }

    before do
      allow(SheetsV4).to(receive(:default_date_and_time_converter).and_return(converter))
      allow(converter).to receive(:datetime_to_gs).with(datetime).and_return(expected_result)
    end

    it 'should call SheetsV4::ConvertDatesAndTimes#datetime_to_gs' do
      expect(subject).to eq(expected_result)
    end
  end

  describe '.gs_to_datetime' do
    subject { described_class.gs_to_datetime(gs_datetime) }
    let(:gs_datetime) { double('gs_datetime') }
    let(:expected_result) { double('expected_result') }
    let(:converter) { double('converter') }

    before do
      allow(SheetsV4).to(receive(:default_date_and_time_converter).and_return(converter))
      allow(converter).to receive(:gs_to_datetime).with(gs_datetime).and_return(expected_result)
    end

    it 'should call SheetsV4::ConvertDatesAndTimes#gs_to_datetime' do
      expect(subject).to eq(expected_result)
    end
  end
end
