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

        def valid_data_types
            [
                'Coverage', 'Condition', 'Encounter', 
                'Observation', 'Patient', 'Procedure'
            ]
        end

        run do
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
        end
    end
end

