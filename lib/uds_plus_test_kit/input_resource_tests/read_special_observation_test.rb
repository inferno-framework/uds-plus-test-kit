require 'json'
require_relative '../ext/fhir_models'

module UDSPlusTestKit
    class ReadSpecialObservationTest < Inferno::Test
        id :uds_plus_read_special_observation_test
        title 'Receive UDS+ Special Observation Data'
        description %(
            Test takes from the user either: the http location of special observation data 
            (such as uds-special-population-observation) or the raw JSON of the data itself.
            It attempts to GET the data stored at the given location if a link is provided,
            then validates whether a FHIR resource can be generated from the input data.
        )

        input :special_observation_data,
            title: 'Special Observation Data',
            optional: true,
            description: %q(
                User can input the data as: 
                a URL link to the location of the data (ex: http://www.example.com/special_observation_data.json) 
                OR a JSON string that composes the data. Leaving this blank will skip the test.
            )
        
        def data_scratch
            scratch[:data_resources] ||= {}
        end

        def data_to_test
            data_scratch['Observation'] ||= []
        end

        run do
            omit_if !special_observation_data.present?, "No data provided; skipping test."

            # if the input is a url, else it is a json
            if special_observation_data.strip[0] != '{'
                assert_valid_http_uri(special_observation_data, "Location provided is not a valid http uri.")
                get special_observation_data
                assert_response_status(200)
                assert_valid_json(request.response_body, "Data received from request is not a valid JSON")
                data = request.response_body
            else
                assert_valid_json(special_observation_data, "JSON inputted was not in a valid format")
                data = special_observation_data
            end
            
            resource = FHIR::Json.from_json(data)
            assert resource.is_a?(FHIR::Model), "Could not generate a valid resource from the input provided"    
            
            if resource.is_a?(FHIR::Model)
                data_to_test << resource
            end
        end
    end
end
