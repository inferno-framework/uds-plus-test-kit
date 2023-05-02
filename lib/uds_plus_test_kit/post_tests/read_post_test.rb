require 'json'


module UDSPlusTestKit
    class ReadPostTest < Inferno::Test
        id :uds_plus_read_post_test
        title 'Read Input from POST Request'
        description %(
            Test takes the file POSTed in the previous test,
            and validates whether a FHIR resource can be generated from the input data.
        )
        
        uses_request :import_manifest

        def manifest_scratch
            scratch[:manifest_resources] ||= {}
        end

        def manifest_resources
            manifest_scratch[:all] ||= []
        end

        run do
            found_resource = FHIR::Json.from_json(request.request_body)
            assert found_resource.is_a?(FHIR::Model), "Could not generate a valid resource from the input provided"    
            
            if found_resource.is_a?(FHIR::Model)
                manifest_resources << found_resource
            end
        end
    end
end
