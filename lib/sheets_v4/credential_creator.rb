# frozen_string_literal: true

require 'json_schemer'

module SheetsV4
  # Creates a Google API credential with an access token
  #
  class CredentialCreator
    # Creates a Google API credential with an access token
    #
    # This wraps the boiler plate code into one function to make constructing a
    # credential easy and less error prone.
    #
    # @example Constructing a credential from the contents of ~/.credential
    #   credential_source = File.read(File.join(Dir.home, '.credential'))
    #   scope = Google::Apis::SheetsV4::AUTH_SPREADSHEETS
    #   credential = GoogleApisHelpers.credential(credential_source, scope)
    #
    # @param [Google::Auth::*, String, IO, nil] credential_source may be one of four things:
    #   (1) a previously created credential that you want to reuse, (2) a credential read
    #   into a string, (3) an IO object with the credential ready to be read, or (4)
    #   if nill, the credential is read from ~/.google-api-credential.json
    # @param scopes [Object, Array] one or more scopes to access.
    # @param credential_factory [#make_creds] Used inject the credential_factory for tests
    #
    # @return [Object] a credential object with an access token
    #
    def self.call(
      credential_source, scopes, credential_factory = Google::Auth::DefaultCredentials
    )
      return credential_source if credential?(credential_source)

      credential_source ||= default_credential_source
      options = make_creds_options(credential_source, scopes)
      credential_factory.make_creds(options).tap(&:fetch_access_token)
    end

    private

    # Reads credential source from `~/.google-api-credential.json`
    #
    # @return [String] the credential as a string
    #
    # @api private
    #
    private_class_method def self.default_credential_source
      File.read(File.expand_path('~/.google-api-credential.json'))
    end

    # Constructs creds_options needed to create a credential
    #
    # @param [Google::Auth::*, String, #read] credential_source a credential (which
    #   is an object whose class is in the Google::Auth module), a String containing
    #   the credential, or a IO object with the credential ready to be read.
    #
    # @return [Hash] returns the cred_options
    #
    # @api private
    #
    private_class_method def self.make_creds_options(credential_source, scopes)
      { json_key_io: to_io(credential_source), scope: scopes }
    end

    # Wraps a credential_source that is a string in a StringIO
    #
    # @param [Google::Auth::*, String, #read] credential_source a credential (which
    #   is an object whose class is in the Google::Auth module), a String containing
    #   the credential, or a IO object with the credential ready to be read.
    #
    # @return [IO, StringIO] returns a StringIO object is a String was passed in.
    #
    # @api private
    #
    private_class_method def self.to_io(credential_source)
      credential_source.is_a?(String) ? StringIO.new(credential_source) : credential_source
    end

    # Determines if a credential_source is already a credential
    #
    # @param [Google::Auth::*, String, #read] credential_source a credential (which
    #   is an object whose class is in the Google::Auth module), a String containing
    #   the credential, or a IO object with the credential ready to be read.
    #
    # @return [Boolean] true if the credential source is an object whose class is in the
    #   Google::Auth module.
    #
    # @api private
    #
    private_class_method def self.credential?(credential_source)
      credential_source.class.name.start_with?('Google::Auth::')
    end
  end
end
