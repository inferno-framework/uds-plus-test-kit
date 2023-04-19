## Documentation
- [Inferno documentation](https://inferno-framework.github.io/inferno-core/)
- [Ruby API documentation](https://inferno-framework.github.io/inferno-core/docs)
- [JSON API documentation](https://inferno-framework.github.io/inferno-core/api-docs)
- [Sample NDJSON Files](https://github.com/drajer-health/uds-plus/tree/master/input/examples/ndjson-samples)

### Useful Methods and Definitions
- [Bundle definition](https://www.rubydoc.info/gems/fhir_client/3.0.2/FHIR/Bundle)
- [Route documentation](https://inferno-framework.github.io/inferno-core/docs/Inferno/DSL/Runnable.html#resume_test_route-instance_method)
- [Resource Profile Definitions](http://fhir.drajer.com/site/artifacts.html#structures-resource-profiles)

## Connectathon Prep Links
- [Connectathon Manager](http://conman.clinfhir.com/connectathon.html?event=con33)
- [Connectathon Manager Tutorial](https://www.youtube.com/watch?v=wBHHgZrSF-k)
- [Old UDS Data Table Info](https://bphc.hrsa.gov/sites/default/files/bphc/data-reporting/2022-uds-tables.pdf)
- [FHIR 101 Video](https://vimeo.com/542197402/8fb80fea04)
- [UDS+ Connectathon Page](https://confluence.hl7.org/pages/viewpage.action?pageId=161056877)


## Important Links in the IG
### [How UDS+ Works](http://fhir.drajer.com/site/usecases.html#uds-data-submission-workflow-using-fhir) 
### [UDS+ Receiver Details](http://fhir.drajer.com/site/reportingguidance.html)
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
