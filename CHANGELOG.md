# Change Log

Changes for each release are listed in this file.

This project adheres to [Semantic Versioning](https://semver.org/) for its releases.

## [0.10.2](https://github.com/main-branch/sheets_v4/compare/v0.10.1...v0.10.2) (2025-04-17)


### Bug Fixes

* Do not trigger build workflows after merging to main or for release PRs ([92d3279](https://github.com/main-branch/sheets_v4/commit/92d32796a9ca032a0805ed0ee83d6a9feecd237d))

## [0.10.1](https://github.com/main-branch/sheets_v4/compare/v0.10.0...v0.10.1) (2025-04-16)


### Bug Fixes

* Automate commit-to-publish workflow ([22e4653](https://github.com/main-branch/sheets_v4/commit/22e4653cc0699225951c1b85bae101677f3dfc04))
* Correctly mark constants as private ([3a7a35e](https://github.com/main-branch/sheets_v4/commit/3a7a35e94fec40759c995c24a7a93085407ee415))

## v0.10.0 (2024-10-11)

[Full Changelog](https://github.com/main-branch/sheets_v4/compare/v0.9.0..v0.10.0)

Changes since v0.9.0:

* 96d390e build: remove semver pr label check
* 54149ee build: enforce conventional commit message formatting
* 29ef270 Use shared Rubocop config
* 39a926d Update copyright notice in this project
* f4be18a Update links in gemspec
* 9c6eae1 Add Slack badge for this project in README
* eae2952 Update yardopts with new standard options
* 24d501c Use standard badges at the top of the README
* 0fb15d3 Standardize YARD and Markdown Lint configurations
* 07db14a Set JRuby --debug option when running tests in GitHub Actions workflows
* fe810d9 Integrate simplecov-rspec into the project
* 256ac35 Update continuous integration and experimental ruby builds
* 3f58109 Enforce the use of semver tags on PRs
* 9be5038 Auto correct Rubocop Gemspec/AddRuntimeDependency offenses
* c800d10 Add links to other gems in the Google API helpers series (#35)
* 207c4d6 Reformat examples/README.md (#34)
* 18b4d9b Move api_object_validation to the discovery_v1 gem (#33)
* cc48f8c Review and update documentation (#32)
* 2f2c8e2 Remove code for no longer used validate_api_object (#31)
* e566cfe Reformat examples (#30)

## v0.9.0 (2023-10-16)

[Full Changelog](https://github.com/main-branch/sheets_v4/compare/v0.8.0..v0.9.0)

Changes since v0.8.0:

* 8fd7ec5 Add convenience methods to Spreadsheet to access Sheets (#28)

## v0.8.0 (2023-10-15)

[Full Changelog](https://github.com/main-branch/sheets_v4/compare/v0.7.0..v0.8.0)

Changes since v0.7.0:

* d8f695c Add extensions to Google::Apis::SheetsV4 classes (#26)
* ed2dc0e Show the cop names on Rubocop offenses when Rubocop is run from Rake (#25)
* c5bfcc1 Group the SheetsV4 methods in the Yard Docs to make them easier to find (#24)

## v0.7.0 (2023-10-08)

[Full Changelog](https://github.com/main-branch/sheets_v4/compare/v0.6.0..v0.7.0)

Changes since v0.6.0:

* 616fe1f Add conversions bewteen Date/DateTime and spreadsheet values (#22)
* 6f37337 Rename SheetsV4::ValidateApiObjects to SheetsV4::ApiObjectValidation (#21)
* 0f76992 Rename SheetsV4::ValidateApiObjects::Validate to SheetsV4::ValidateApiObjects::ValidateApiObject (#20)
* e80040c Rename SheetsV4::CredentialCreator to SheetsV4::CreateCredential (#19)

## v0.6.0 (2023-10-03)

[Full Changelog](https://github.com/main-branch/sheets_v4/compare/v0.5.0..v0.6.0)

Changes since v0.5.0:

* 2eab61d Update documentation explaining how to construct and validate a request (#17)

## v0.5.0 (2023-10-01)

[Full Changelog](https://github.com/main-branch/sheets_v4/compare/v0.4.0..v0.5.0)

Changes since v0.4.0:

* b403430 Refactor SheetsV4.validate_api_object (#15)

## v0.4.0 (2023-09-29)

[Full Changelog](https://github.com/main-branch/sheets_v4/compare/v0.3.0..v0.4.0)

Changes since v0.3.0:

* 843c1b5 Add SheetsV4.sheets_service (#13)
* 16a73f5 Refactor ValidateApiObject (#12)
* 1525cd3 Add a link in the README to the Sheet V4 API Discover Doc (#11)
* 6d5bfb3 Improve color api and documentation (#10)

## v0.3.0 (2023-09-28)

[Full Changelog](https://github.com/main-branch/sheets_v4/compare/v0.2.0..v0.3.0)

Changes since v0.2.0:

* 0fb4579 Add predefined color objects (#8)

## v0.2.0 (2023-09-26)

[Full Changelog](https://github.com/main-branch/sheets_v4/compare/v0.1.1..v0.2.0)

Changes since v0.1.1:

* 489ff50 Add SheetsV4.validate_api_object (#6)
* b44eba4 List all examples that should be created (#5)
* 2edd688 Add links to Google Sheets documentation to the README.md (#4)

## v0.1.1 (2023-09-22)

[Full Changelog](https://github.com/main-branch/sheets_v4/compare/v0.1.0..v0.1.1)

Changes since v0.1.0:

* 06597e9 Use the correct Code Climate test reporter ID (#2)

## v0.1.0 (2023-09-22)

[Full Changelog](https://github.com/main-branch/sheets_v4/compare/63753b4..v0.1.0)

Changes:

* 63753b4 Initial version
