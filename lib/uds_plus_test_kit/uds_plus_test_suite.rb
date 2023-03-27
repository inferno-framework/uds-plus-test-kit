require 'inferno/dsl/oauth_credentials'
require 'smart_app_launch_test_kit'
require_relative './version'

module UDSPlusTestKit
    class UDSPlusTestSuite < Inferno::TestSuite
        title 'UDS+ Test Kit'
        description %(
            The UDS+ Test Kit tests systems for their conformance to the [UDS+
            Implementation Guide](http://fhir.drajer.com/site/index.html#uds-plus-home-page).
        )

        version VERSION

        def self.metadata
            @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
                Generator::GroupMetadata.new(raw_metadata)
            end
        end
    
        validator do
            url ENV.fetch('V120_VALIDATOR_URL', 'http://validator_service:4567')
        end

        id :uds_plus

        input :url,
            title: 'FHIR Endpoint',
            description: 'URL of the FHIR endpoint'
        input :smart_credentials,
            title: 'OAuth Credentials',
            type: :oauth_credentials,
            optional: true

        fhir_client do
            url :url
            oauth_credentials :smart_credentials
        end

        # Test Groups go here
    end
end