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
      url 'http://localhost:8084/udsplus-validator/'
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
        warning_message = []
        
        # Iterate through the 'issues' in the response body
        response_body['issues'].each do |issue|
          issue['issue'].each do |sub_issue|
            # Initialize empty arrays inside the loop if needed to prevent duplicate appending
            sub_error_messages = []
            sub_warning_messages = []
            
            # Check if severity is 'error'
            if sub_issue['severity'] == 'error'
              coding = sub_issue['details']['coding']
              if coding && coding.is_a?(Array)
                coding.each do |code|
                  sub_error_messages << code['display'] if code['display']
                end
              end
              # Add all the error messages and fail the test if severity is 'error'
              sub_error_messages.each { |msg| add_message('error', "#{msg}") }
              error_messages.concat(sub_error_messages)  # Append only the newly found error messages
            elsif sub_issue['severity'] == 'warning'
              coding = sub_issue['details']['coding']
              if coding && coding.is_a?(Array)
                coding.each do |code|
                  sub_warning_messages << code['display'] if code['display']
                end
              end
              # Add all the warning messages and log them if severity is 'warning'
              sub_warning_messages.each { |msg| add_message('warning', "#{msg}") }
              warning_message.concat(sub_warning_messages)  # Append only the newly found warning messages
            end
          end
        end
      
        assert false, "Test failed due to unexpected response status: #{response.status}"
      end         
      # Make sure the response status is 202 for success
      assert_response_status(202)
    end
  end
end
