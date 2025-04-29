module UDSPlusTestKit
    class InvalidTypeTest < Inferno::Test
        id :uds_plus_invalid_type_test
        title 'Check For Invalid Types in Import Manifest'
        description %(
            Test checks the titles of the data URLs found in
            the import manifest, and verifies that each of
            the titles provided matches with a known UDS+ data 
            type. Test returns a list of unmatched types found 
            in the manifest, or passes if all titles are valid.
        )

        def data_scratch
            scratch[:data_resources] ||= {}
        end

        def observation_data
            data_scratch['Observation'] ||= []
        end

        def valid_data_types
            [
                'Coverage', 'Condition', 'Encounter', 
                'Observation', 'Patient', 'Procedure',
                'RelatedPerson', 'Immunization',
                'ServiceRequest', 'MedicationRequest', 
                'MedicationStatement', 'Location',
                'AdverseEvent', 'AllergyIntolerance',
                'Parameters'
            ]
        end

        run do
            identifier_fail_message = %(Resource.meta.profile should contain the HTTP location of the 
                                        resource's Structure Definition. Resource.meta.profile either does 
                                        not exist in this resource, or its contents do not point to a valid
                                        location for type Parameters. **NOTE:**
                                        If this error occurs, it can trigger a fail for all parameters-type tests, 
                                        regardless of whether both tests were meant to run.)

            invalid_types_found = []
            data_scratch.keys.each do |data_type|
                if !valid_data_types.include?(data_type)
                    invalid_types_found << data_type
                end
            end

            fail_message = %(
                The following invalid resource types were declared 
                in the import manifest: #{invalid_types_found}.
            )
            assert invalid_types_found.empty?, fail_message

            # For 2.0.0 release of IG, all types of Observation resources have been strongly defined. Move validation step of whether all Observation
            # resources submitted match one of the known types from the Special Observation test to here
            invalid_observations_found = []
            observation_data.each do |resource|
                # All these assertions are to differentiate Observation data between orientation types.
                # A resource is skipped if it is one of the observation types with their own tests.
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
                
                known_observations = ["income", "-lab-", "clinical-result", "uds-plus-observation"]
                is_known_observation = false
                known_observations.each do |cur|
                    is_known_observation = (is_known_observation || type_identifier.include?(cur))
                end

                if !is_known_observation
                    invalid_observations_found << type_identifier
                end
            end

            observation_fail_message = %(
                The following invalid observation types were referenced 
                in the import manifest: #{invalid_observations_found}.
            )
            assert invalid_observations_found.empty?, observation_fail_message
        end
    end
end

