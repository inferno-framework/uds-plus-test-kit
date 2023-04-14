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

        PROFILE_VERSION = '0.3.0'
        PROFILE = {
            'SexualOrientation' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-sexual-orientation-observation',
            'ImportManifest' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-import-manifest',
            'Income' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-income-observation',
            'DeIdentifyData' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-deidentify-data',
            'Procedure' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-procedure',
            'Patient' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/de-identified-uds-plus-patient',
            'Encounter' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-encounter',
            'Coverage' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-coverage',
            'Diagnosis' => 'http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-diagnosis'
        }

        id :uds_plus

        # Example urls generated here
        patient_ex = File.read(File.join(__dir__, 'examples/patient.ndjson'))
        patient_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [patient_ex]] }
        route(:get, "/examples/patient", patient_ex_route_handler)

        condition_ex = File.read(File.join(__dir__, 'examples/condition.ndjson'))
        condition_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [condition_ex]] }
        route(:get, "/examples/condition", condition_ex_route_handler)

        encounter_ex = File.read(File.join(__dir__, 'examples/encounter.ndjson'))
        encounter_ex_route_handler = proc { [200, { 'Content-Type' => 'application/ndjson' }, [encounter_ex]] }
        route(:get, "/examples/encounter", encounter_ex_route_handler)

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

            # Manifest Receiver
            test do
                id :uds_plus_receiver_test
                title 'Receive UDS+ Import Manifest'
                description %(
                    Test takes from the user either: the http location of the import manifest 
                    or the raw JSOn of the import manifest itself.
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

                #output :manifest
                
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
                    
                    #output manifest: manifest
                end
            end

            # Manifest Validator
            test do
                id :uds_plus_validate_manifest_test
                title 'Validate UDS+ Import Manifest'
                description %(
                    Test takes the resource generated by the prior test,
                    and validates whether the resource conforms to the 
                    UDS+ Import Manifest Structure Definition.
                )

                #input :manifest

                def manifest_scratch
                    scratch[:manifest_resources] ||= {}
                end

                def manifest_resources
                    manifest_scratch[:all] ||= []
                end

                run do
                    profile_with_version = "#{PROFILE['ImportManifest']}|#{PROFILE_VERSION}"
                    #assert_valid_resource(resource: manifest_resources.first, profile_url: profile_with_version)
                    assert_valid_resource(resource: manifest_resources.first)
                end
            end
                        
            # Data Read
            test do
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

                #input :manifest
                run do
                    skip_if manifest_resources.empty?, "No valid resource object generated in first test, so this test will be skipped."

                    manifest_hash = JSON.parse(manifest_resources.first.to_json)
                    manifest_content = manifest_hash['parameter']

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

                        assert PROFILE.keys.include?(profile_name), %(
                            Manifest defines contents as type #{profile_name},
                            which is not a defined UDS+ Profile type.
                        )

                        data_scratch[profile_name] ||= []

                        invalid_uri_message = "Invalid URL provided for type #{profile_name}"
                        assert_valid_http_uri(profile_url, invalid_uri_message)
                        
                        get profile_url
                        assert_response_status(200)

                        #request.response_body.delete("\n").gsub(/\} *\{/, "}SPLIT HERE{").split("SPLIT HERE").each do |json_body|
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

            # Data Validator
            test do
                id :uds_plus_validate_data_test
                title 'Validate UDS+ Data'
                description %(
                    Test takes the resource generated by the prior test,
                    and validates whether the resources conform to their 
                    UDS+ Structure Definitions.
                )

                def data_scratch
                    scratch[:data_resources] ||= {}
                end

                run do
                    skip_if data_scratch.empty?, "No data was saved during the prior test."

                    data_scratch.keys.each do |profile_name|
                        next if PROFILE.keys.include?(profile_name)

                        profile_definition = PROFILE[profile_name]
                        profile_with_version = "#{profile_definition}|#{PROFILE_VERSION}"

                        data_scratch[profile_name].each do |resource|
                            assert_valid_resource(resource: resource, profile_url: profile_with_version)
                        end
                    end
                end
            end
        end
    end
end
