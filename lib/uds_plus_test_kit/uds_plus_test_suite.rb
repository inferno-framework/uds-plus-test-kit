require 'inferno/dsl/oauth_credentials'
require_relative './version'
require_relative './manifest_tests/uds_plus_test_group'
require_relative './input_resource_tests/resource_group'
require_relative './post_tests/post_group'

module UDSPlusTestKit
    class UDSPlusTestSuite < Inferno::TestSuite
        title 'UDS+ Test Kit'
        description %(
            The UDS+ Test Kit tests systems for their conformance to the [UDS+
            Implementation Guide](http://fhir.drajer.com/index.html#uds-plus-home-page).
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

        # Example urls generated here
        patient_ex = File.read(File.join(__dir__, 'examples/patient.ndjson'))
        patient_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [patient_ex]] }
        route(:get, "/examples/patient", patient_ex_route_handler)

        condition_ex = File.read(File.join(__dir__, 'examples/condition.ndjson'))
        condition_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [condition_ex]] }
        route(:get, "/examples/condition", condition_ex_route_handler)

        encounter_ex = File.read(File.join(__dir__, 'examples/encounter.ndjson'))
        encounter_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [encounter_ex]] }
        route(:get, "/examples/encounter", encounter_ex_route_handler)

        manifest_ex = File.read(File.join(__dir__, 'examples/manifest.json'))
        manifest_ex_route_handler = proc { [200, { 'Content-Type' => 'application/json' }, [manifest_ex]] }
        route(:get, "/examples/manifest", manifest_ex_route_handler)
        
        bad_condition_ex = File.read(File.join(__dir__, 'examples/invalid_condition.ndjson'))
        bad_condition_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [bad_condition_ex]] }
        route(:get, "/examples/invalid_condition", bad_condition_ex_route_handler)

        bad_patient_ex = File.read(File.join(__dir__, 'examples/invalid_patient.ndjson'))
        bad_patient_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [bad_patient_ex]] }
        route(:get, "/examples/invalid_patient", bad_patient_ex_route_handler)

        bad_encounter_ex = File.read(File.join(__dir__, 'examples/invalid_encounter.ndjson'))
        bad_encounter_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [bad_encounter_ex]] }
        route(:get, "/examples/invalid_encounter", bad_encounter_ex_route_handler)

        observation_ex = File.read(File.join(__dir__, 'examples/observation.ndjson'))
        observation_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [observation_ex]] }
        route(:get, "/examples/observation", observation_ex_route_handler)

        # Receive Manifest via POST set-up
        resume_test_route :post, '/postHere' do |request|
            request.query_parameters["id"]
        end

        links [
            {
              label: 'Report Issue',
              url: 'https://github.com/inferno-framework/uds-plus-test-kit/issues'
            },
            {
              label: 'Open Source',
              url: 'https://github.com/inferno-framework/uds-plus-test-kit/'
            },
            {
              label: 'UDS+ Implementation Guide',
              url: 'http://fhir.drajer.com/index.html#uds-plus-home-page'
            }
          ]

        group from: :uds_plus_test_group
        group from: :uds_plus_manifest_post_group 
        group from: :uds_plus_resource_test_group
    end
end
