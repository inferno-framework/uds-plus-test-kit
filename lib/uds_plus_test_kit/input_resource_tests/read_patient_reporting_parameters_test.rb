require 'json'

module UDSPlusTestKit
    class ReadPatientReportingParametersTest < Inferno::Test
        id :uds_plus_read_patient_reporting_parameters_test
        title 'Receive UDS+ Patient Reporting Parameters Data'
        description %(
            Test takes from the user either: the http location of patient reporting parameters data 
            or the raw JSON of the data itself.
            It attempts to GET the data stored at the given location if a link is provided,
            then validates whether a FHIR resource can be generated from the input data.
        )

        input :patient_reporting_parameters_data,
            title: 'Patient Reporting Parameters Data',
            optional: true,
            description: %q(
                User can input the data as: 
                a URL link to the location of the data (ex: http://www.example.com/patient_reporting_parameters_data.json) 
                OR a JSON string that composes the data. Leaving this blank will skip the test.
            )
        
        def data_scratch
            scratch[:data_resources] ||= {}
        end

        def data_to_test
            data_scratch['Parameters'] ||= []
        end

        run do
            omit_if !patient_reporting_parameters_data.present?, "No data provided; skipping test."

            # if the input is a url, else it is a json
            if patient_reporting_parameters_data.strip[0] != '{'
                assert_valid_http_uri(patient_reporting_parameters_data, "Location provided is not a valid http uri.")
                get patient_reporting_parameters_data
                assert_response_status(200)
                assert_valid_json(request.response_body, "Data received from request is not a valid JSON")
                data = request.response_body
            else
                assert_valid_json(patient_reporting_parameters_data, "JSON inputted was not in a valid format")
                data = patient_reporting_parameters_data
            end
            
            resource = FHIR::Json.from_json(data)
            assert resource.is_a?(FHIR::Model), "Could not generate a valid resource from the input provided"    
            
            if resource.is_a?(FHIR::Model)
                data_to_test << resource
            end
        end
    end
end
