require_relative './version'

module UDSPlusTestKit
    module ValidateData
        ######### MOVE THIS TO WHERE TEST IS CALLED ##################
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

        def get_profile_type(cur_resource)
            profile_type = "ERROR"
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