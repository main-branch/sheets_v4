# frozen_string_literal: true

RSpec.describe SheetsV4::ValidateApiObjects::LoadSchemas do
  let(:schemas_loader) { described_class.new(logger:) }
  let(:logger) { Logger.new(nil) }

  describe '#initialize' do
    subject { schemas_loader }

    it { is_expected.to have_attributes(logger:) }
  end

  describe '#call' do
    subject { schemas_loader.call }

    let(:uri) { URI.parse('https://sheets.googleapis.com/$discovery/rest?version=v4') }

    before do
      allow(Net::HTTP).to(
        receive(:get_response)
          .with(uri)
          .and_return(double('response', code: '200', body: api_description, uri:))
      )
    end

    let(:api_description) { <<~JSON }
      {
        "kind": "discovery#restDescription",
        "schemas": {
          "GridData": {
            "id": "GridData",
            "type": "object",
            "properties": {
              "rowData": { "type": "array", "items": { "$ref": "RowData" } },
              "startRow": { },
              "startColumn": { }
            }
          },
          "RowData": {
            "id": "RowData",
            "type": "object",
            "properties": {
              "values": { "type": "array", "items": { "$ref": "CellData" } }
            }
          },
          "CellData": {
            "id": "CellData",
            "properties": {
              "userEnteredValue": { "$ref": "ExtendedValue" }
            }
          }
        }
      }
    JSON

    it 'should raise a RuntimeError if the HTTP response code is not a "200"' do
      allow(Net::HTTP).to(
        receive(:get_response)
          .with(uri)
          .and_return(double('response', code: '500', body: 'error', uri:))
      )
      expect { subject }.to raise_error(RuntimeError)
    end

    it 'should return the schemas from the Google Discovery API' do
      expect(subject).to be_a(Hash)
      expect(subject).to have_attributes(size: 3)
    end

    it 'should only load the schemas once' do
      described_class.remove_instance_variable(:@api_object_schemas) if
        described_class.instance_variable_defined?(:@api_object_schemas)

      expect(Net::HTTP).to(
        receive(:get_response)
          .with(uri)
          .once.and_return(double('response', body: api_description, code: '200', uri:))
      )
      2.times { schemas_loader.call }
    end

    it 'should convert schema names to snake case' do
      expect(subject.keys).to eq(%w[grid_data row_data cell_data])
    end

    it 'should convert schema IDs to snake case' do
      expect(subject['grid_data']['id']).to eq('grid_data')
      expect(subject['row_data']['id']).to eq('row_data')
      expect(subject['cell_data']['id']).to eq('cell_data')
    end

    it 'should add "unevaluatedProperties: false" to all schemas' do
      expect(subject['grid_data']['unevaluatedProperties']).to eq(false)
      expect(subject['row_data']['unevaluatedProperties']).to eq(false)
      expect(subject['cell_data']['unevaluatedProperties']).to eq(false)
    end

    it 'should convert object property names to snake case' do
      expect(subject['grid_data']['properties'].keys).to eq(%w[row_data start_row start_column])
      expect(subject['row_data']['properties'].keys).to eq(['values'])
      expect(subject['cell_data']['properties'].keys).to eq(['user_entered_value'])
    end

    it 'should convert reference values to snake case' do
      expect(subject['grid_data']['properties']['row_data']['items']['$ref']).to eq('row_data')
      expect(subject['row_data']['properties']['values']['items']['$ref']).to eq('cell_data')
      expect(subject['cell_data']['properties']['user_entered_value']['$ref']).to eq('extended_value')
    end
  end
end
