require 'inferno/dsl/oauth_credentials'
require_relative './ext/fhir_models'
require_relative './version'
require_relative './manifest_tests/uds_plus_test_group'
require_relative './input_resource_tests/resource_group'

module UDSPlusTestKit
    class UDSPlusTestSuite < Inferno::TestSuite
        title 'UDS+ Test Kit'
        description %(
            The UDS+ Test Kit tests systems for their conformance to the [UDS+
            Implementation Guide](http://fhir.drajer.com/site/index.html#uds-plus-home-page).
            The included tests function as a rudimentary data receiver. This receiver will 
            take a provided Import Manifest, either as an HTTP location or as a raw json,
            and validate its contents. This includes validating the structure of the manifest,
            as well as the structure of the data the manifest points to.
        )

        version VERSION

        validator do
            url ENV.fetch('VALIDATOR_URL', 'http://validator_service:4567')

            # Messages will be excluded if the block evaluates to a truthy value
            exclude_message do |message|
                message.type == 'warning' &&
                message.message.match?(/Global Profile reference .* could not be resolved, so has not been checked/)
            end
        end

        id :uds_plus

        group from: :uds_plus_test_group
        group from: :uds_plus_resource_test_group
    end
end
