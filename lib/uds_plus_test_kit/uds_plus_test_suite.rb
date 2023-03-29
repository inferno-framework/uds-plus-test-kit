require 'inferno/dsl/oauth_credentials'
require 'smart_app_launch_test_kit'
require_relative './version'
require_relative './validate_data'

module UDSPlusTestKit
    class UDSPlusTestSuite < Inferno::TestSuite
        title 'UDS+ Test Kit'
        description %(
            The UDS+ Test Kit tests systems for their conformance to the [UDS+
            Implementation Guide](http://fhir.drajer.com/site/index.html#uds-plus-home-page).
        )

        version VERSION

        def self.metadata
            @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
                Generator::GroupMetadata.new(raw_metadata)
            end
        end

        # These inputs will be available to all tests in this suite
        input :url, 
            title: 'FHIR Server Base Url'

        input :credentials,
            title: 'OAuth Credentials',
            type: :oauth_credentials,
            optional: true

        # All FHIR requests in this suite will use this FHIR client
        fhir_client do
            url :url
            oauth_credentials :credentials
        end
    
        validator do
            url ENV.fetch('V120_VALIDATOR_URL', 'http://validator_service:4567')
        end

        resume_test_route :get, '/submission' do |request|
            request.resource
        end

        config options: {
            submission_uri: "#{Inferno::Application['base_url']}/custom/uds/submission"
        }

        id :uds_plus

        group do
            # Receiver
            test do
                input :issuer
                receives_request :submission
                
                run do
                    wait(
                        identifier: issuer, 
                        message: "Waiting to receive request."
                    )

                    assert request.status == "200", %(
                        Import attempt failed. 
                        Response status = #{request.status}"
                    )
                    assert request.resource.present?, 
                        'No recource received from import.'
                end
            end
                        
            # Validator
            test do
                uses_request :submission
                run do
                    resource = request.resource
                    
                    assert resource.is_a?(FHIR::Model)
                    skip_if !resource.is_a?(FHIR::Model), %(
                        Import recieved does not match FHIR conventions. 
                        Skipping remainder of test
                    )

                    perform_validation_test('UDSPlusImportManifest', [resource])

                    #Iterate through the types provided by the resource (pseudocode for now)
                    #TODO: change list_of_types to whatever the import manifest calls it
                    
                    resource.list_of_types.each do |type, link|
                        profile_type = get_profile_type(type)
                        
                        #TODO: Figure out how to retrieve info from the url
                        profile_resource = read_url(link)
                        assert profile_resource.list_of_instances.present?,
                            "Manifest does not provide valid instances of #{profile_type}"
                        
                        resources = []
                        #TODO: change list_of_instances to whatever the import manifest calls it
                        profile_resources.list_of_instances.each do |instance|
                            resources << instance
                        end

                        perform_validation_test(profile_type, resources)
                    end
                end
            end
        end
    end
end