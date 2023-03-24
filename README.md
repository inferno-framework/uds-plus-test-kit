## Documentation
- [Inferno documentation](https://inferno-framework.github.io/inferno-core/)
- [Ruby API documentation](https://inferno-framework.github.io/inferno-core/docs)
- [JSON API documentation](https://inferno-framework.github.io/inferno-core/api-docs)

## Important Links in the IG
### [How UDS+ Works](http://fhir.drajer.com/site/usecases.html#uds-data-submission-workflow-using-fhir) 
### [Possible Outside Test Kits to Integrate](http://fhir.drajer.com/site/background.html#underlying-specifications)
These include:
- US Core FHIR IG
- FHIR Bulk Data Access IG
- [SMART App Launch Backend Services Authorization](http://fhir.drajer.com/site/spec.html#smart-on-fhir-backend-services-authorization) 
### [In-Scope Requirements](http://fhir.drajer.com/site/background.html#ig-in-scope-requirements) 
-	Define the API mechanisms, Inputs, and Outputs used to access data from the EHRs/IT systems (Data Sources) and exchange data.
-	Define the mechanisms used to start the data submission workflows.
-	Define the provisioning mechanisms used to automate the triggering and submission of data.
-	Define trust services (e.g., pseudonymization, anonymization, de-identification, hashing) needed to ensure de-identified data is sent from the health centers to HRSA.
-	Define an alternative mechanism for health centers to submit data using XML files when submitting data using FHIR is not an option.
### [Claiming Conformance](http://fhir.drajer.com/site/spec.html#claiming-conformance)
-	Systems SHALL be capable of populating data elements as specified by the profiles and data elements are returned using the specified APIs in the capability statement.
-	Systems SHALL be capable of processing resource instances containing the MUST SUPPORT data elements without generating an error or causing the application to fail.
-	In situations where information on a particular data element is not present and the reason for absence is unknown, Systems SHALL NOT include the data elements in the resource instance returned from executing the API requests.
-	When accessing UDS+ data, Systems SHALL interpret missing data elements within resource instances returned from API requests as data not present.
###	[System Actors, Requirements and Capability Statements](http://fhir.drajer.com/site/spec.html#system-actors-requirements-and-capability-statements)
-	Data Source 
-	Data Submitter
-	Data Receiver
-	Trust Service Provider
### [Artifact Summary and Behavior](http://fhir.drajer.com/site/artifacts.html)
- Capability Statements
- Operation Definitions
- Resource Profiles
- Extension Definitions
