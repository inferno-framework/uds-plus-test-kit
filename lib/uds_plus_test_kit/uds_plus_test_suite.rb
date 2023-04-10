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

        validator do
            url ENV.fetch('VALIDATOR_URL', 'http://validator_service:4567')
        end

        PROFILE = {
            'SexualOrientation' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-sexual-orientation-observation'.freeze,
            'ImportManifest' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-import-manifest'.freeze,
            'Income' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-income-observation'.freeze,
            'DeIdentifyData' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-deidentify-data'.freeze,
            'Procedure' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-procedure'.freeze,
            'Patient' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/de-identified-uds-plus-patient'.freeze,
            'Encounter' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-encounter'.freeze,
            'Coverage' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-coverage'.freeze,
            'Diagnosis' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-diagnosis'.freeze
        }.freeze

        id :uds_plus

        group do
            title 'UDS+ Submission Tests'
            id :uds_plus_submitter_group
            description %(
                The included tests function as a rudimentary Data receiver.
                This receiver will retrieve the import sent by the given 
                Health Center Submitter, confirm a secure connection, and
                validate whether the import's contents adhere to the UDS+ 
                configuration.
            )

            run_as_group

            # Receiver
            test do
                id :uds_plus_receiver_test
                title 'Receive a UDS+ Import Manifest'
                description %(
                    Test takes an import location provided by the user. 
                    It attempts to GET the data stored at the given location,
                    then validates whether the data claims to be an Import 
                    Manifest, and that it adheres to UDS+ Manifest guidelines.
                )

                input :import_location,
                    title: 'Data Submitter Endpoint',
                    description: 'The url the receiver looks to for the input manifest'
                makes_request :submission
                
                # Manifest Test
                run do
                    assert_valid_http_uri(import_location, "Import manifest uri location is not a valid http uri.")
                    get import_location, name: :submission

                    assert_response_status(200)
                    assert_valid_json(request.response_body)

                    assert resource.present?, 
                        'No recource received from import.'
                    skip_if !resource.present?, %(
                        Import recieved does not contain a valid resource. 
                        Skipping remainder of test."
                    )
                    
                    assert resource.is_a?(FHIR::Model)
                    skip_if !resource.is_a?(FHIR::Model), %(
                        Import recieved does not match FHIR conventions. 
                        Skipping remainder of test
                    )

                    assert_valid_resource(resource: resource, profile_url: 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-import-manifest')                    
                end
            end
                        
            # Validator
            test do
                id :uds_plus_validate_test
                title 'Validate the contents of the import manifest'
                description %(
                    Test iterates through the data that the Import Manifest 
                    links to. It validates wheter data is found at the given points,
                    and that said data adheres to UDS+ guidelines as provided for
                    its claimed data type
                )

                uses_request :submission
                run do
                    #resource = submission.resource
                    manifest = JSON.parse(request.response_body)
                    manifest_content = manifest['parameter']

                    #Iterate through the types provided by the resource (pseudocode for now)
                    #TODO: change list_of_types to whatever the import manifest calls it     
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

                        valid_profile = PROFILE.keys.include?(profile_name)
                        profile_definition = "NO TYPE"
                        assert valid_profile, %(
                            Manifest defines contents as type #{profile_name},
                            which is not a defined UDS+ Profile type.
                        )

                        invalid_uri_message = "Invalid URL provided for type #{profile_name}"
                        assert_valid_http_uri(profile_url, invalid_uri_message)
                        
                        #TODO: Figure out how to retrieve info from the url
                        get profile_url
                        assert_response_status(200)

                        #profile_resources = []
                        request.response_body.gsub("}{", "}SPLIT HERE{").split("SPLIT HERE").each do |json_body|
                            assert_valid_json(json_body)

                            resource = FHIR::Json.from_json(json_body)
                            assert_valid_resource(resource: resource, profile_url: profile_definition)
                        end
                    end
                end
            end
        end
    end
end
