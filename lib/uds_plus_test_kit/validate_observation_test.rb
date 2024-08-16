require 'json'
require_relative './version'

module UDSPlusTestKit
    class ValidateLabTest < Inferno::Test
        id :uds_plus_validate_observation_test
        title 'Validate UDS+ Observation Data'
        description %(
            Test takes the Observation resources identified 
            by the import manifest, and validates whether they conform 
            to their UDS+ Structure Definitions (not including UDS+ specialized observation resources).
        )

        def data_scratch
            scratch[:data_resources] ||= {}
        end

        def data_to_test
            data_scratch['Observation'] ||= []
        end

        run do
            omit_if data_to_test.empty?, "No data of this type was identified."

            profile_definition = 'http://fhir.org/guides/hrsa/uds-plus/StructureDefinition/uds-plus-observation'
            profile_with_version = "#{profile_definition}|#{UDS_PLUS_VERSION}"

            no_resource_of_this_type = true
            identifier_fail_message = %(Resource.meta.profile should contain the HTTP location of the 
                                        resource's Structure Definition. Resource.meta.profile either does 
                                        not exist in this resource, or its contents do not point to a valid
                                        location for type Observation. **NOTE:**
                                        If this error occurs, it can trigger a fail for all observation-type tests, 
                                        regardless of whether all such tests were meant to run.)

            data_to_test.each do |resource|
                # All these assertions are to differentiate Observation data between orientation types.
                # A resource is skipped if it cannot be identified as a general observation resource.
                type_identifier = resource.to_hash
                assert type_identifier['meta'].present?, identifier_fail_message

                type_identifier = type_identifier['meta']
                assert type_identifier.is_a?(Hash), identifier_fail_message
                assert type_identifier['profile'].present?, identifier_fail_message

                type_identifier = type_identifier['profile']
                assert type_identifier.is_a?(Array), identifier_fail_message
                assert !type_identifier.empty?, identifier_fail_message


                type_identifier = type_identifier.first
                assert type_identifier.is_a?(String), identifier_fail_message
                if !type_identifier.include?("uds-plus-observation")
                    next
                end
                    
                no_resource_of_this_type = false

                assert_valid_resource(resource: resource, profile_url: profile_with_version)
            end

            omit_if no_resource_of_this_type, "No data of this type was identified."
        end
    end
end