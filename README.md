## Documentation
- [Inferno documentation](https://inferno-framework.github.io/inferno-core/)
- [Ruby API documentation](https://inferno-framework.github.io/inferno-core/docs)
- [JSON API documentation](https://inferno-framework.github.io/inferno-core/api-docs)
- [UDS+ Implementation Guide](https://fhir.org/guides/hrsa/uds-plus/)

## Connectathon Links
- [Connectathon Manager](http://conman.clinfhir.com/connectathon.html?event=con33)
- [Connectathon Manager Tutorial](https://www.youtube.com/watch?v=wBHHgZrSF-k)
- [FHIR 101 Video](https://vimeo.com/542197402/8fb80fea04)
- [UDS+ Connectathon Page](https://confluence.hl7.org/pages/viewpage.action?pageId=161056877)

## Version
**Test Kit:** 1.1.0
**IG:** 1.1.2

### Notes From the Developers
- There are known issues with validating certain codesets (not resource structure) when running this kit locally. If you are running locally and encounter an "Unknown Code" error for a given resource, try running that same resource on the hosted version of the kit and see if the codeset can be validated there.