require 'json'
require_relative './ext/fhir_models'

module UDSPlusTestKit
    class ReadManifestTest < Inferno::Test
        id :uds_plus_read_manifest_test
        title 'Receive UDS+ Import Manifest'
        description %(
            Test takes from the user either: the http location of the import manifest 
            or the raw JSON of the import manifest itself.
            It attempts to GET the data stored at the given location if a link is provided,
            then validates whether a FHIR resource can be generated from the input data.
        )

        input :import_manifest,
            title: 'Import Manifest',
            description: %q(
                User can input the Import manifest as: 
                a URL link to the location of the manifest (ex: http://www.example.com/import_manifest.json) OR 
                a JSON string that composes the manifest (ex: {manifest_contents}) 
            )
        
        def manifest_scratch
            scratch[:manifest_resources] ||= {}
        end

        def manifest_resources
            manifest_scratch[:all] ||= []
        end

        run do
            # if the input is a url, else it is a json
            if import_manifest.strip[0] != '{'
                assert_valid_http_uri(import_manifest, "Import manifest uri location is not a valid http uri.")
                get import_manifest
                assert_response_status(200)
                assert_valid_json(request.response_body, "Data received from request is not a valid JSON")
                manifest = request.response_body
            else
                assert_valid_json(import_manifest, "JSON inputted was not in a valid format")
                manifest = import_manifest
            end
            
            resource = FHIR::Json.from_json(manifest)
            assert resource.is_a?(FHIR::Model), "Could not generate a valid resource from the input provided"    
            
            if resource.is_a?(FHIR::Model)
                manifest_resources << resource
            end
        end
    end
end
