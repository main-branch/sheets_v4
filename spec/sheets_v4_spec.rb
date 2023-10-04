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

  describe '.validate_api_object' do
    subject { described_class.validate_api_object(schema_name:, object:, logger:) }
    let(:schema_name) { double('schema_name') }
    let(:object) { double('object') }
    let(:logger) { double('logger') }

    it 'should call SheetsV4::ValidateApiObjects::ValidateApiObject to do the validation' do
      expect(SheetsV4::ValidateApiObjects::ValidateApiObject).to(
        receive(:new)
        .with(logger:)
        .and_call_original
      )
      expect_any_instance_of(SheetsV4::ValidateApiObjects::ValidateApiObject).to(
        receive(:call)
        .with(schema_name:, object:)
      )
      subject
    end
  end

  describe '.api_object_schema_names' do
    subject { described_class.api_object_schema_names(logger:) }
    let(:logger) { double('logger') }
    let(:schema_loader) { double('schema_loader') }
    let(:schemas) { double('schemas') }
    let(:schema_names) { %w[schema1 schema2] }
    let(:expected_result) { double('expected_result') }

    before do
      allow(SheetsV4::ValidateApiObjects::LoadSchemas).to(
        receive(:new)
        .with(logger:)
        .and_return(schema_loader)
      )
      allow(schema_loader).to receive(:call).and_return(schemas)
      allow(schemas).to receive(:keys).and_return(schema_names)
    end

    it 'should call SheetsV4::ValidateApiObjects::LoadSchemas to load the schemas' do
      expect(subject).to eq(schema_names)
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
end
