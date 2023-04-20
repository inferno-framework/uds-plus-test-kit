require_relative '../ext/fhir_models'
require_relative '../version'
require_relative './read_coverage_test'
require_relative './read_diagnosis_test'
require_relative './read_encounter_test'
require_relative './read_income_test'
require_relative './read_patient_test'
require_relative './read_procedure_test'
require_relative './read_sexual_orientation_test'
require_relative '../validate_coverage_test'
require_relative '../validate_diagnosis_test'
require_relative '../validate_encounter_test'
require_relative '../validate_income_test'
require_relative '../validate_patient_test'
require_relative '../validate_procedure_test'
require_relative '../validate_sexual_orientation_test'

module UDSPlusTestKit
    class UDSPlusResourceTestGroup < Inferno::TestGroup
        title 'Individual Resource Tests'
        id :uds_plus_resource_test_group
        description %(
            The tests below skip the import manifest step. Instead, 
            users can input individual resources, either by url or as 
            a raw json, and have these resources validated. **Importand Note:**
            The purpose of these tests is to quickly retest a specific resource that
            previously failed. The test can only handle one json resource per type,
            unlike the manifest test, which can handle an ndjson containing many objects.
        )

        run_as_group

        test from: :uds_plus_read_coverage_test
        test from: :uds_plus_validate_coverage_test
        test from: :uds_plus_read_diagnosis_test
        test from: :uds_plus_validate_diagnosis_test
        test from: :uds_plus_read_encounter_test
        test from: :uds_plus_validate_encounter_test
        test from: :uds_plus_read_income_test
        test from: :uds_plus_validate_income_test
        test from: :uds_plus_read_patient_test
        test from: :uds_plus_validate_patient_test
        test from: :uds_plus_read_procedure_test
        test from: :uds_plus_validate_procedure_test
        test from: :uds_plus_read_sexual_orientation_test
        test from: :uds_plus_validate_sexual_orientation_test
    end
end