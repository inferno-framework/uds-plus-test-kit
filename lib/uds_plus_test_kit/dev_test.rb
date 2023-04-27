module UDSPlusTestKit
    class DevTest < Inferno::TestGroup
        title 'Dev Test'
        id :dev_test
        description %(
            Space to test ruby functions.
        )

        test do
            input :test_choice,
                title: "Enter number",
                description: "1=good, 2=income, 3=no_aray, 4=no_profile, 5=bad_meta"
            run do
                good_hash = { 'meta' => {'profile' => ["http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-sexual-orientation-observation"]}}
                income_hash = { 'meta' => {'profile' => ["http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-income-observation"]}}
                no_array_hash = { 'meta' => {'profile' => "http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-sexual-orientation-observation"}}
                no_profile_hash = { 'meta' => {'prafile' => ["http://hl7.org/fhir/us/uds-plus/StructureDefinition/uds-plus-sexual-orientation-observation"]}}
                bad_meta_hash = { 'meta' => "bad"}

                test_hash = nil
                choice = test_choice.to_i
                if choice == 1
                    test_hash = good_hash
                elsif choice == 2
                    test_hash = income_hash
                elsif choice == 3
                    test_hash = no_array_hash
                elsif choice == 4
                    test_hash = no_profile_hash
                else
                    test_hash = bad_meta_hash
                end

                assert test_hash['meta'].present?, "Couldn't find meta. this shouldnt ever happen"

                test_hash = test_hash['meta']
                assert test_hash.is_a?(Hash), "meta is not a hash. Choice 5"
                assert test_hash['profile'].present?, "Couldnt find profile. Choice 4"

                test_hash = test_hash['profile']
                assert test_hash.is_a?(Array), "Profile is not an array. Choice 3"
                assert !test_hash.empty?, "The test hash is empty?? I know this would work. I shouldn't ever see this"


                test_hash = test_hash.first
                assert test_hash.is_a?(String), "The url is not a string. I shouldn't ever see this"
                assert test_hash.include?("sexual-orientation"), "Not a SO url. Choice 2"
            end
        end
    end
end