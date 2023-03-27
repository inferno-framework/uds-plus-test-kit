module UDSPlusTestKit
    module ReceiveData
        def http_get(route_path, handler)
            route(:get, route_path, handler)
        end

        def wait_for_request(issuer)
            wait(identifier: issuer, message: "Waiting to receive request")
        end


    end
end