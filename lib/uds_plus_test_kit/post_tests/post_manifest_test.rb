require 'json'


module UDSPlusTestKit
    class PostManifestTest < Inferno::Test
        id :uds_plus_post_manifest_test
        title 'Receive UDS+ Import Manifest via POST request'
        description %(
            Test waits for an import manifest to be posted at the 
            provided location. Test passes if it recieves a post
            request within 3 mins of test start.
        )

        receives_request :import_manifest

        def id_gen
            output = ''
            ranNum = Random.new
            for _ in 1..10
                output += ranNum.rand(10).to_s
            end
            output
        end

        run do
            session_id = id_gen
            wait(
                identifier: session_id,
                timeout: 300,
                message: %(
                    Post your Import Manifest JSON to the following URL:
                    #{Inferno::Application['base_url']}/custom/uds_plus/postHere?id=#{session_id}

                    If the test times out or is cancelled for any reason, rerunning the test group will restart the timeout.

                    Your request body MUST be your Import Manifest in raw json format. Testing will resume automatically after a valid POST is received.
                )
            )
        end
    end
end
