require 'json'
require_relative './version'

module UDSPlusTestKit
  class ValidateRestApiTest < Inferno::Test
    id :uds_plus_validate_rest_api_test
    title 'Validate UDS + REST API Test '
    description 'This test validates the REST API endpoint for UDS+ data submission.'

    def manifest_scratch
      scratch[:manifest_resources] ||= {}
  end

  def manifest_resources
      manifest_scratch[:all] ||= []
  end

    http_client do
      url 'http://137.117.90.167:8084/udsplus-validator/'
    end


    run do
      # Send the POST request
      response = post '$validate', body: manifest_resources.first.to_json, headers: {
        'client-id': 'fqhc_utah',
        'Prefer' => 'respond-async',
        'Content-Type' => 'application/fhir+json',
        'Accept' => 'application/fhir+json'
      }
    
      # Check the response status
      if response.status == 202
        # Access and parse the response body
        response_body = JSON.parse(response.response_body)
    
        # Extract the desired message from the response
        success_message = response_body.dig('issues', 0, 'issue', 0, 'details', 'coding', 0, 'display')
    
        # Log the extracted message as info
        info "#{success_message}"
      else
        # Access and parse the response body even if the status is not 202
        response_body = JSON.parse(response.response_body)
        error_messages = []
      
        response_body['issues'].each do |issue|
          issue['issue'].each do |sub_issue|
            # Check if severity is 'error'
            if sub_issue['severity'] == 'error'
              coding = sub_issue['details']['coding']
              if coding && coding.is_a?(Array)
                coding.each do |code|
                  error_messages << code['display'] if code['display']
                end
              end
            end
          end
        end
        # Log all the error messages and fail the test if severity is 'error'
        error_messages.each { |msg| add_message('error', "#{msg}") }
        assert false, "Test failed due to unexpected response status: #{response.status}"
      end      
      # Make sure the response status is 202 for success
      assert_response_status(202)
    end
  end
end
