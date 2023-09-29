# frozen_string_literal: true

require 'logger'
require 'net/http'

RSpec.describe SheetsV4 do
  it 'has a version number' do
    expect(SheetsV4::VERSION).not_to be nil
  end

  let(:schemas) do
    {
      'PersonSchema' => {
        'type' => 'object',
        'properties' => {
          'name' => { 'type' => 'string' },
          'location' => { '$ref' => 'LocationSchema' },
          'active' => { 'type' => 'boolean' }
        }
      },
      'LocationSchema' => {
        'type' => 'object',
        'properties' => {
          'city' => { 'type' => 'string' },
          'state' => { 'type' => 'string' }
        }
      }
    }
  end
  let(:sheets_discovery_uri) { URI.parse('https://sheets.googleapis.com/$discovery/rest?version=v4') }
  let(:sheets_discovery_document) { double('sheets_discovery_document', body: JSON.generate('schemas' => schemas)) }
  before do
    allow(Net::HTTP).to(
      receive(:get_response)
      .with(sheets_discovery_uri)
      .and_return(sheets_discovery_document)
    )
  end

  describe '.validate_api_object' do
    subject { described_class.validate_api_object(schema_name:, object:, logger:) }
    let(:schema_name) { 'PersonSchema' }
    let(:object) do
      { 'name' => 'James', 'location' => { 'city' => 'Temecula', 'state' => 'CA' }, 'active' => true }
    end

    let(:logger) { Logger.new(nil) }

    it 'validates the object against the schema' do
      expect { subject }.not_to raise_error
    end

    context 'with an object that does not conform to the schema' do
      let(:object) { { 'name' => 'James', 'banned' => false } }
      it 'should raise an error if the object is not valid' do
        expect { subject }.to raise_error(RuntimeError, /does not conform/)
      end
    end
  end

  describe '.self.api_object_schemas' do
    it 'should return the schemas from the Google Discovery API for Sheets V4' do
      expect(described_class.api_object_schemas).to have_attributes(keys: %w[PersonSchema LocationSchema])
    end

    it 'should return the PersonSchema adding the unevaluatedProperties=false property' do
      expected_schema = schemas['PersonSchema'].merge('unevaluatedProperties' => false)
      expect(described_class.api_object_schemas['PersonSchema']).to eq(expected_schema)
    end

    it 'should return the LocationSchema adding the unevaluatedProperties=false property' do
      expected_schema = schemas['LocationSchema'].merge('unevaluatedProperties' => false)
      expect(described_class.api_object_schemas['LocationSchema']).to eq(expected_schema)
    end
  end

  describe '.color' do
    it 'should return the color object for the given name' do
      SheetsV4::COLORS.each_key do |color_name|
        expect(described_class.color(color_name)).to eq(SheetsV4::COLORS[color_name])
      end
    end
  end
end
