# frozen_string_literal: true

RSpec.describe SheetsV4::CredentialCreator do
  describe '.call' do
    subject { described_class.call(credential_source, scopes, credential_factory) }

    let(:scopes) { double('scopes') }
    let(:credential_factory) { double('credential_factory') }

    context 'credential_source is a Google::Auth::*' do
      let(:credential_source) do
        double('credential_source', class: double('credential_class', name: 'Google::Auth::Test'))
      end

      it 'should use return the credential_source' do
        expect(subject).to eq(credential_source)
      end
    end

    context 'credential_source is a String' do
      let(:credential_source) { 'credential as a string' }
      let(:credential) { double('credential') }
      it 'should use the string to make the credential' do
        expect(credential_factory).to(
          receive(:make_creds)
            .with({ json_key_io: StringIO, scope: scopes })
            .and_return(credential)
        )
        expect(credential).to receive(:fetch_access_token)
        expect(subject).to eq(credential)
      end
    end

    context 'credential_source is an IO' do
      let(:credential_source) { StringIO.new('credential as a string') }
      let(:credential) { double('credential') }
      it 'should read the credential from the IO object' do
        expect(credential_factory).to(
          receive(:make_creds)
            .with({ json_key_io: credential_source, scope: scopes })
            .and_return(credential)
        )
        expect(credential).to receive(:fetch_access_token)
        expect(subject).to eq(credential)
      end
    end

    context 'credential_source is nil' do
      let(:credential_source) { nil }
      let(:credential) { double('credential') }
      it 'should read the credential from ~/.google-api-credential.json' do
        allow(File).to receive(:expand_path).and_call_original
        allow(File).to receive(:read).and_call_original
        expect(File).to receive(:expand_path).with('~/.google-api-credential.json').and_return('path')
        expect(File).to receive(:read).with('path').and_return('credential as a string')

        expect(credential_factory).to(
          receive(:make_creds)
            .with({ json_key_io: StringIO, scope: scopes })
            .and_return(credential)
        )

        expect(credential).to receive(:fetch_access_token)
        expect(subject).to eq(credential)
      end
    end
  end
end
