require 'inferno/dsl/oauth_credentials'
require_relative './manifest_tests/uds_plus_test_group'
require_relative './input_resource_tests/resource_group'
require_relative './post_tests/post_group'

module UDSPlusTestKit
    class UDSPlusTestSuite < Inferno::TestSuite
        title 'UDS+ Test Kit'
        description %(
            The UDS+ Test Kit tests systems for their conformance to the [UDS+
            Implementation Guide v2.0.0](https://fhir.org/guides/hrsa/uds-plus/STU2).
            The included tests function as a rudimentary data receiver. This receiver will
            take a provided Import Manifest, either as an HTTP location or as a raw json,
            and validate its contents. This includes validating the structure of the manifest,
            as well as the structure of the data the manifest points to.
        )

        fhir_resource_validator do
            # The home-lab-report contains validation tools for certain codes missing in the UDS+ package
            igs('fhir.hrsa.uds-plus#2.0.0', 'hl7.fhir.us.home-lab-report#1.0.0')

            cli_context do
              displayWarnings true
            end

            # Messages will be excluded if the block evaluates to a truthy value
            exclude_message do |message|
                message.message.match?(/\A\S+: \S+: URL value '.*' does not resolve/) ||
                (message.type == 'warning' &&
                message.message.match?(/Global Profile reference .* could not be resolved, so has not been checked/)) ||
                (message.type == 'error' &&
                Inferno::Application['base_url'].match?(/localhost:/) &&
                message.message.match?(/: Code .* not found in CPT;/))
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

        adverse_event_ex = File.read(File.join(__dir__, 'examples/adverse_event.ndjson'))
        adverse_event_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [adverse_event_ex]] }
        route(:get, "/examples/adverse_event", adverse_event_ex_route_handler)

        allergy_intollerance_ex = File.read(File.join(__dir__, 'examples/allergy_intollerance.ndjson'))
        allergy_intollerance_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [allergy_intollerance_ex]] }
        route(:get, "/examples/allergy_intollerance", allergy_intollerance_ex_route_handler)

        coverage_ex = File.read(File.join(__dir__, 'examples/coverage.ndjson'))
        coverage_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [coverage_ex]] }
        route(:get, "/examples/coverage", coverage_ex_route_handler)

        immunization_ex = File.read(File.join(__dir__, 'examples/immunization.ndjson'))
        immunization_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [immunization_ex]] }
        route(:get, "/examples/immunization", immunization_ex_route_handler)

        medication_request_ex = File.read(File.join(__dir__, 'examples/medication_request.ndjson'))
        medication_request_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [medication_request_ex]] }
        route(:get, "/examples/medication_request", medication_request_ex_route_handler)

        medication_statement_ex = File.read(File.join(__dir__, 'examples/medication_statement.ndjson'))
        medication_statement_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [medication_statement_ex]] }
        route(:get, "/examples/medication_statement", medication_statement_ex_route_handler)

        procedure_ex = File.read(File.join(__dir__, 'examples/procedure.ndjson'))
        procedure_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [procedure_ex]] }
        route(:get, "/examples/procedure", procedure_ex_route_handler)

        related_person_ex = File.read(File.join(__dir__, 'examples/related_person.ndjson'))
        related_person_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [related_person_ex]] }
        route(:get, "/examples/related_person", related_person_ex_route_handler)

        reporting_parameters_ex = File.read(File.join(__dir__, 'examples/reporting_parameters.ndjson'))
        reporting_parameters_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [reporting_parameters_ex]] }
        route(:get, "/examples/reporting_parameters", reporting_parameters_ex_route_handler)

        service_request_ex = File.read(File.join(__dir__, 'examples/service_request.ndjson'))
        service_request_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [service_request_ex]] }
        route(:get, "/examples/service_request", service_request_ex_route_handler)

        data_urls_ex = File.read(File.join(__dir__, 'examples/data_urls.ndjson'))
        data_urls_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [data_urls_ex]] }
        route(:get, "/examples/data_urls", data_urls_ex_route_handler)

        location_ex = File.read(File.join(__dir__, 'examples/location.ndjson'))
        location_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [location_ex]] }
        route(:get, "/examples/location", location_ex_route_handler)

        # Receive Manifest via POST set-up
        resume_test_route :post, '/postHere' do |request|
            request.query_parameters["id"]
        end

        links [
            {
              type: 'report_issue',
              label: 'Report Issue',
              url: 'https://github.com/inferno-framework/uds-plus-test-kit/issues'
            },
            {
              type: 'source_code',
              label: 'Open Source',
              url: 'https://github.com/inferno-framework/uds-plus-test-kit/'
            },
            {
              type: 'download',
              label: 'Download',
              url: 'https://github.com/inferno-framework/uds-plus-test-kit/releases/'
            },
            {
              type: 'ig',
              label: 'UDS+ Implementation Guide v2.0.0',
              url: 'https://fhir.org/guides/hrsa/uds-plus/STU2'
            }
          ]

        group from: :uds_plus_test_group
        group from: :uds_plus_manifest_post_group
        group from: :uds_plus_resource_test_group
    end
end
