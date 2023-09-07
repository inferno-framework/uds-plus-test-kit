require 'json'

module UDSPlusTestKit
    class ReadAdverseEventTest < Inferno::Test
        id :uds_plus_read_adverse_event_test
        title 'Receive UDS+ Adverse Event Data'
        description %(
            Test takes from the user either: the http location of adverse event data 
            or the raw JSON of the data itself.
            It attempts to GET the data stored at the given location if a link is provided,
            then validates whether a FHIR resource can be generated from the input data.
        )

        input :adverse_event_data,
            title: 'Adverse Event Data',
            optional: true,
            description: %q(
                User can input the data as: 
                a URL link to the location of the data (ex: http://www.example.com/adverse_event_data.json) 
                OR a JSON string that composes the data. Leaving this blank will skip the test.
            )
        
        def data_scratch
            scratch[:data_resources] ||= {}
        end

        def data_to_test
            data_scratch['AdverseEvent'] ||= []
        end

        run do
            omit_if !adverse_event_data.present?, "No data provided; skipping test."

            # if the input is a url, else it is a json
            if adverse_event_data.strip[0] != '{'
                assert_valid_http_uri(adverse_event_data, "Adverse Event provided is not a valid http uri.")
                get adverse_event_data
                assert_response_status(200)
                assert_valid_json(request.response_body, "Data received from request is not a valid JSON")
                data = request.response_body
            else
                assert_valid_json(adverse_event_data, "JSON inputted was not in a valid format")
                data = adverse_event_data
            end
            
            resource = FHIR::Json.from_json(data)
            assert resource.is_a?(FHIR::Model), "Could not generate a valid resource from the input provided"    
            
            if resource.is_a?(FHIR::Model)
                data_to_test << resource
            end
        end
    end
end