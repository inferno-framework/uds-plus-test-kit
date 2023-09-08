# Note on packages
### uds-plus-package.tgz
This package is the base tgz file for the UDS+ IG, v1.0.0. It contains the vast majority of data for the validator service. However, it has some gaps in its ability to validate certain identifier codes, and therefore must be supplemented by an external package.

### external-package.tgz
This is a package used by the at-home-in-vitro IG. It contains validation tools for certain codes that are missing in the UDS+ package

### Plan
The UDS+ kit will be able to stand independently once the next release of the IG is deployed. Once the internal package is updated, the external package will be removed.