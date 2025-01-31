require_relative 'version'

module UDSPlusTestKit
  class Metadata < Inferno::TestKit
    id :uds_plus
    title 'UDS+ Test Kit'
    description <<~DESCRIPTION
      The UDS+ Test Kit validates the conformance of a server to the [UDS+ IG v1.1.0](https://fhir.org/guides/hrsa/uds-plus/STU1.1/). The included tests function as a rudimentary data receiver. This receiver will take a provided Import Manifest, either as an HTTP location or as a raw json, and validate its contents. This includes validating the structure of the manifest, as well as the structure of the data the manifest points to.
      <!-- break -->
      This test kit is built using the [Inferno Framework](https://inferno-framework.github.io/docs/). The Inferno Framework is designed for reuse and aims to make it easier to build test kits for any FHIR-based data exchange.

      ### Status

      The test kit currently tests the following requirements:

        - That a given import manifest structure and the structure of the data the manifest points to are valid
        - Receiving an import manifest by POST request
        - Receiving and validating individual resources by URL or raw JSON

      See the test descriptions within the test kit for detail on the specific validations performed as part of testing these requirements.

      ### Repository

      The UDS+ Test Kit GitHub repository can be [found here](https://github.com/inferno-framework/uds-plus-test-kit).

      ### Providing Feedback and Reporting Issues

      Please report any issues with this set of tests in the [issues section](https://github.com/inferno-framework/uds-plus-test-kit/issues) of the repository.
    DESCRIPTION
    suite_ids [:uds_plus]
    tags ['']
    last_updated LAST_UPDATED
    version VERSION
    maturity 'Low'
    authors ['Leap Orbit']
    repo 'https://github.com/inferno-framework/uds-plus-test-kit'
  end
end
