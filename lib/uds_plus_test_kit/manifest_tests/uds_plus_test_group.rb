require_relative '../version'
require_relative './invalid_type_test'
require_relative './read_data_test'
require_relative './read_manifest_test'
require_relative '../validate_coverage_test'
require_relative '../validate_diagnosis_test'
require_relative '../validate_encounter_test'
require_relative '../validate_income_test'
require_relative './validate_manifest_test'
require_relative '../validate_patient_test'
require_relative '../validate_procedure_test'
require_relative '../validate_sexual_orientation_test'
require_relative '../validate_special_observation_test'
require_relative '../validate_related_person_test'
require_relative '../validate_immunization_test'
require_relative '../validate_lab_test'
require_relative '../validate_med_request_test'
require_relative '../validate_med_statement_test'
require_relative '../validate_service_request_test'

module UDSPlusTestKit
    class UDSPlusTestGroup < Inferno::TestGroup
        title 'Import Manifest Tests'
        id :uds_plus_test_group 
        description %(
            The tests below validate the import manifest produced by a UDS+ Data Submitter. 
            This receiver will take a provided Import Manifest, either as an HTTP location or 
            as a raw json, and validate its contents. This includes validating the structure 
            of the manifest, as well as the structure of the data the manifest points to.
        )

        run_as_group

        test from: :uds_plus_read_manifest_test
        test from: :uds_plus_validate_manifest_test
        test from: :uds_plus_read_data_test
        test from: :uds_plus_validate_coverage_test
        test from: :uds_plus_validate_diagnosis_test
        test from: :uds_plus_validate_encounter_test
        test from: :uds_plus_validate_patient_test
        test from: :uds_plus_validate_procedure_test
        test from: :uds_plus_validate_related_person_test
        test from: :uds_plus_validate_immunization_test
        test from: :uds_plus_validate_income_test
        test from: :uds_plus_validate_sexual_orientation_test
        test from: :uds_plus_validate_lab_test
        test from: :uds_plus_validate_special_observation_test
        test from: :uds_plus_validate_medication_request_test
        test from: :uds_plus_validate_medication_statement_test
        test from: :uds_plus_validate_service_request_test
        test from: :uds_plus_invalid_type_test
    end
end