require 'json'

module UDSPlusTestKit
    class ReadDataTest < Inferno::Test
        id :uds_plus_read_data_test
        title 'Read the contents of the import manifest'
        description %(
            Test iterates through the data that the Import Manifest 
            links to. It validates whether an ndjson is found at the given points,
            and if FHIR models can be created by the values enclosed.
        )

        def manifest_scratch
            scratch[:manifest_resources] ||= {}
        end

        def manifest_resources
            manifest_scratch[:all] ||= []
        end

        def data_scratch
            scratch[:data_resources] ||= {}
        end

        def manifest_content
            return [] if manifest_resources.empty?
            manifest_hash = JSON.parse(manifest_resources.first.to_json)
            manifest_hash['parameter'] ||= []
        end

        run do
            skip_if manifest_content.empty?, "No valid resource object generated in first test, so this test will be skipped."
  
            manifest_content.each do |source|
                #Iterate through manifest until udsData is found
                next if source['name'] != 'udsData'

                profile_name = "NO NAME"
                profile_url = "NO URL"
                source['part'].each do |container|
                    case container['name']
                    when 'type'
                        profile_name = container['valueCode']
                    when 'url'
                        profile_url = container['valueUrl']
                    end
                end

                assert profile_name != "NO NAME" && profile_url != "NO URL", %(
                    Input Manifest is not configured such that resource type and url
                    for a given input is conventionally accessible.
                )

                data_scratch[profile_name] ||= []

                invalid_uri_message = "Invalid URL provided for type #{profile_name}"
                assert_valid_http_uri(profile_url, invalid_uri_message)
                
                get profile_url
                assert_response_status(200)

                request.response_body.each_line do |json_body|                            
                    assert_valid_json(json_body)

                    resource = FHIR::Json.from_json(json_body)

                    assert resource.is_a?(FHIR::Model), "Could not generate a valid resource from the #{profile_name} input provided" 
                    if resource.is_a?(FHIR::Model)
                        data_scratch[profile_name] << resource
                    end
                end
            end
        end
    end
end