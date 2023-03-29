require_relative './version'

module UDSPlusTestKit
    module ValidateData
        DAR_CODE_SYSTEM_URL = 'http://terminology.hl7.org/CodeSystem/data-absent-reason'.freeze
        DAR_EXTENSION_URL = 'http://hl7.org/fhir/StructureDefinition/data-absent-reason'.freeze
        PROFILE = {
            'UDSPlusSexualOrientation' => 'http://fhir.drajer.com/site/StructureDefinition-uds-plus-sexual-orientation-observation.html'.freeze,
            'UDSPlusImportManifest' => 'http://fhir.drajer.com/site/StructureDefinition-uds-plus-import-manifest.html'.freeze,
            'UDSPlusIncome' => 'http://fhir.drajer.com/site/StructureDefinition-uds-plus-income-observation.html'.freeze,
            'UDSPlusDeIdentifyData' => 'http://fhir.drajer.com/site/StructureDefinition-uds-plus-deidentify-data.html'.freeze,
            'UDSPlusProcedure' => 'http://fhir.drajer.com/site/StructureDefinition-uds-plus-procedure.html'.freeze,
            'DeIdentifiedUDSPlusPatient' => 'http://fhir.drajer.com/site/StructureDefinition-de-identified-uds-plus-patient.html'.freeze,
            'UDSPlusEncounter' => 'http://fhir.drajer.com/site/StructureDefinition-uds-plus-encounter.html'.freeze,
            'UDSPlusCoverage' => 'http://fhir.drajer.com/site/StructureDefinition-uds-plus-coverage.html'.freeze,
            'UDSPlusDiagnosis' => 'http://fhir.drajer.com/site/StructureDefinition-uds-plus-diagnosis.html'.freeze
        }.freeze

        def perform_validation_test(profile_type, resources)
            skip_if resources.blank?, "No resources provided for this iteration of the validation test"
            assert profile_type != "NO MATCH", "Resource does not claim to match the id of any of the provided profile types"
            skip_if profile_type == "NO MATCH", "Resource does not match any profile types; skipping remainder of test"

            profile_version = VERSION
            profile_url = PROFILE[profile_type]

            profile_with_version = "#{profile_url}|#{profile_version}"
            resources.each do |resource|
                resource_is_valid?(resource: resource, profile_url: profile_with_version)
                check_for_dar(resource)
            end

            errors_found = messages.any? { |message| message[:type] == 'error' }

            assert !errors_found, "Resource of type #{profile_type} does not conform to the profile #{profile_with_version}"
        end

        def check_for_dar(resource)
            unless scratch[:dar_code_found]
                resource.each_element do |element, meta, _path|
                    next unless element.is_a?(FHIR::Coding)

                    check_for_dar_code(element)
                end
            end

            unless scratch[:dar_extension_found]
                check_for_dar_extension(resource)
            end
        end

        def check_for_dar_code(coding)
            return unless coding.code == 'unknown' && coding.system == DAR_CODE_SYSTEM_URL

            scratch[:dar_code_found] = true
            output dar_code_found: 'true'
        end

        def check_for_dar_extension(resource)
            return unless resource.source_contents&.include? DAR_EXTENSION_URL

            scratch[:dar_extension_found] = true
            output dar_extension_found: 'true'
        end

        def get_profile_type(cur_resource)
            profile_type = "NO MATCH"
            if cur_resource.is_a? FHIR::Model::UDSPlusSexualOrientation
                profile_type = 'UDSPlusSexualOrientation'
            elsif cur_resource.is_a? FHIR::Model::UDSPlusImportManifest
                profile_type = 'UDSPlusImportManifest'
            elsif cur_resource.is_a? FHIR::Model::UDSPlusIncome
                profile_type = 'UDSPlusIncome'
            elsif cur_resource.is_a? FHIR::Model::UDSPlusDeIdentifyData
                profile_type = 'UDSPlusDeIdentifyData'
            elsif cur_resource.is_a? FHIR::Model::UDSPlusProcedure
                profile_type = 'UDSPlusProcedure'
            elsif cur_resource.is_a? FHIR::Model::DeIdentifiedUDSPlusPatient
                profile_type = 'DeIdentifiedUDSPlusPatient'
            elsif cur_resource.is_a? FHIR::Model::UDSPlusEncounter
                profile_type = 'UDSPlusEncounter'
            elsif cur_resource.is_a? FHIR::Model::UDSPlusCoverage
                profile_type = 'UDSPlusCoverage'
            elsif cur_resource.is_a? FHIR::Model::UDSPlusDiagnosis
                profile_type = 'UDSPlusDiagnosis'
            end
            profile_type
        end
    end
end