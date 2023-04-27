require 'inferno/dsl/oauth_credentials'
#require 'smart_app_launch_test_kit'
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
        end

        PROFILE = {
            'SexualOrientation' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-sexual-orientation-observation',
            'ImportManifest' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-import-manifest',
            'Income' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-income-observation',
            'DeIdentifyData' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-deidentify-data',
            'Procedure' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-procedure',
            'Patient' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/de-identified-uds-plus-patient',
            'Encounter' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-encounter',
            'Coverage' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-coverage',
            'Condition' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-diagnosis'
        }

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

        group from: :uds_plus_test_group
        group from: :uds_plus_resource_test_group
    end
end
