require_relative '../version'
require_relative './read_coverage_test'
require_relative './read_diagnosis_test'
require_relative './read_encounter_test'
require_relative './read_income_test'
require_relative './read_patient_test'
require_relative './read_procedure_test'
require_relative '../validate_coverage_test'
require_relative '../validate_diagnosis_test'
require_relative '../validate_encounter_test'
require_relative '../validate_income_test'
require_relative '../validate_patient_test'
require_relative '../validate_procedure_test'
require_relative './read_manifest_ind_test'
require_relative '../manifest_tests/validate_manifest_test'
require_relative './read_observation_test'
require_relative '../validate_observation_test'
require_relative './read_related_person_test'
require_relative '../validate_related_person_test'
require_relative './read_immunization_test'
require_relative '../validate_immunization_test'
require_relative './read_lab_test'
require_relative '../validate_lab_test'
require_relative './read_med_request_test'
require_relative '../validate_med_request_test'
require_relative './read_med_statement_test'
require_relative '../validate_med_statement_test'
require_relative './read_service_request_test'
require_relative '../validate_service_request_test'
require_relative './read_location_test'
require_relative '../validate_location_test'
require_relative './read_allergy_intolerance_test'
require_relative '../validate_allergy_intolerance_test'
require_relative './read_adverse_event_test'
require_relative '../validate_adverse_event_test'
require_relative './read_clinical_result_test'
require_relative '../validate_clinical_result_test'
require_relative './read_data_urls_test'
require_relative '../validate_data_urls_test'
require_relative './read_patient_reporting_parameters_test'
require_relative '../validate_patient_reporting_parameters_test'

module UDSPlusTestKit
    class UDSPlusResourceTestGroup < Inferno::TestGroup
        title 'Individual Resource Tests'
        id :uds_plus_resource_test_group
        description %(
            The tests below skip the import manifest step. Instead, 
            users can input individual resources, either by url or as 
            a raw json, and have these resources validated. **Important Note:**
            The purpose of these tests is to quickly test a specific resource. 
            The test can only handle one json resource per type, unlike the 
            Data Submitter test, which can handle an ndjson containing many objects.
        )

        run_as_group

        test from: :uds_plus_read_manifest_ind_test
        test from: :uds_plus_validate_manifest_test
        test from: :uds_plus_read_coverage_test
        test from: :uds_plus_validate_coverage_test
        test from: :uds_plus_read_diagnosis_test
        test from: :uds_plus_validate_diagnosis_test
        test from: :uds_plus_read_encounter_test
        test from: :uds_plus_validate_encounter_test
        test from: :uds_plus_read_patient_test
        test from: :uds_plus_validate_patient_test
        test from: :uds_plus_read_procedure_test
        test from: :uds_plus_validate_procedure_test
        test from: :uds_plus_read_related_person_test
        test from: :uds_plus_validate_related_person_test
        test from: :uds_plus_read_immunization_test
        test from: :uds_plus_validate_immunization_test
        test from: :uds_plus_read_location_test
        test from: :uds_plus_validate_location_test
        test from: :uds_plus_read_allergy_intolerance_test
        test from: :uds_plus_validate_allergy_intolerance_test
        test from: :uds_plus_read_adverse_event_test
        test from: :uds_plus_validate_adverse_event_test
        test from: :uds_plus_read_income_test
        test from: :uds_plus_validate_income_test
        test from: :uds_plus_read_lab_test
        test from: :uds_plus_validate_lab_test
        test from: :uds_plus_read_clinical_result_test
        test from: :uds_plus_validate_clinical_result_test
        test from: :uds_plus_read_observation_test
        test from: :uds_plus_validate_observation_test
        test from: :uds_plus_read_medication_request_test
        test from: :uds_plus_validate_medication_request_test
        test from: :uds_plus_read_medication_statement_test
        test from: :uds_plus_validate_medication_statement_test
        test from: :uds_plus_read_service_request_test
        test from: :uds_plus_validate_service_request_test
        test from: :uds_plus_read_data_urls_test
        test from: :uds_plus_validate_data_urls_test
        test from: :uds_plus_read_patient_reporting_parameters_test
        test from: :uds_plus_validate_patient_reporting_parameters_test
    end
end