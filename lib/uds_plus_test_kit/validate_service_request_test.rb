require 'json'
require_relative './ext/fhir_models'
require_relative './version'

module UDSPlusTestKit
    class ValidateServiceRequestTest < Inferno::Test
        id :uds_plus_validate_service_request_test
        title 'Validate UDS+ Service Request Data'
        description %(
            Test takes the Service Request resources identified 
            by the import manifest, and validates whether they conform 
            to their UDS+ Structure Definitions.
        )

        def data_scratch
            scratch[:data_resources] ||= {}
        end

        def data_to_test
            data_scratch['ServiceRequest'] ||= []
        end

        run do
            omit_if data_to_test.empty?, "No data of this type was identified."

            profile_definition = 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-servicerequest'
            profile_with_version = "#{profile_definition}|#{UDS_PLUS_VERSION}"

            data_to_test.each do |resource|
                assert_valid_resource(resource: resource, profile_url: profile_with_version)
            end
        end
    end
end
