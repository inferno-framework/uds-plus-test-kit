require 'json'
require_relative './ext/fhir_models'
require_relative './version'

module UDSPlusTestKit
    class ValidatePatientTest < Inferno::Test
        id :uds_plus_validate_patient_test
        title 'Validate UDS+ Patient Data'
        description %(
            Test takes the Patient resources identified 
            by the import manifest, and validates whether they conform 
            to their UDS+ Structure Definitions.
        )

        def data_scratch
            scratch[:data_resources] ||= {}
        end

        def data_to_test
            data_scratch['Patient'] ||= []
        end

        run do
            omit_if data_to_test.empty?, "No data of this type was identified in the import manifest."

            profile_definition = 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/de-identified-uds-plus-patient'
            profile_with_version = "#{profile_definition}|#{UDS_PLUS_VERSION}"

            puts ""
            puts profile_with_version
            puts ""

            data_to_test.each do |resource|
                assert_valid_resource(resource: resource, profile_url: profile_with_version)
            end
        end
    end
end
