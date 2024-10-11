# SheetsV4

[![Gem Version](https://badge.fury.io/rb/sheets_v4.svg)](https://badge.fury.io/rb/sheets_v4)
[![Documentation](https://img.shields.io/badge/Documentation-Latest-green)](https://rubydoc.info/gems/sheets_v4/)
[![Change Log](https://img.shields.io/badge/CHANGELOG-Latest-green)](https://rubydoc.info/gems/sheets_v4/file/CHANGELOG.md)
[![Build Status](https://github.com/main-branch/sheets_v4/actions/workflows/continuous_integration.yml/badge.svg)](https://github.com/main-branch/sheets_v4/actions/workflows/continuous_integration.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/aeebc016487c5cad881e/maintainability)](https://codeclimate.com/github/main-branch/sheets_v4/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/aeebc016487c5cad881e/test_coverage)](https://codeclimate.com/github/main-branch/sheets_v4/test_coverage)
[![Conventional
Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![Slack](https://img.shields.io/badge/slack-main--branch/sheets__v4-yellow.svg?logo=slack)](https://main-branch.slack.com/archives/C07N5ULJQU9)

Unofficial helpers and extensions for the Google Sheets V4 API

Gems in the Google API helper, extensions, and examples series:

* [discovery_v1](https://github.com/main-branch/discovery_v1)
* [drive_v3](https://github.com/main-branch/drive_v3)
* [sheets_v4](https://github.com/main-branch/sheets_v4)

## Contents

* [Contents](#contents)
* [Installation](#installation)
* [Examples](#examples)
* [Important links for programming Google Sheets](#important-links-for-programming-google-sheets)
  * [SheetsV4 documenation](#sheetsv4-documenation)
  * [General API documentation](#general-api-documentation)
  * [Ruby implementation of the Sheets API](#ruby-implementation-of-the-sheets-api)
  * [Other links](#other-links)
* [Getting started](#getting-started)
  * [Create a Google Cloud project](#create-a-google-cloud-project)
  * [Enable the APIs you want to use](#enable-the-apis-you-want-to-use)
  * [Download a Google API credential file](#download-a-google-api-credential-file)
* [Usage](#usage)
  * [Obtaining an authenticated SheetsService](#obtaining-an-authenticated-sheetsservice)
  * [Building a request](#building-a-request)
    * [Method 1: constructing requests using `Google::Apis::SheetsV4::*` objects](#method-1-constructing-requests-using-googleapissheetsv4-objects)
    * [Method 2: constructing requests using hashes](#method-2-constructing-requests-using-hashes)
    * [Which method should be used?](#which-method-should-be-used)
  * [Validating requests](#validating-requests)
  * [Google Extensions](#google-extensions)
    * [SheetsService Extensions](#sheetsservice-extensions)
    * [Spreadsheet Extensions](#spreadsheet-extensions)
    * [Sheet Extensions](#sheet-extensions)
  * [Working with dates and times](#working-with-dates-and-times)
  * [Working with colors](#working-with-colors)
* [Development](#development)
* [Contributing](#contributing)
  * [Commit message guidelines](#commit-message-guidelines)
  * [Pull request guidelines](#pull-request-guidelines)
* [License](#license)

## Installation

Install the gem and add to the application's Gemfile by executing:

```shell
bundle add sheets_v4
```

If bundler is not being used to manage dependencies, install the gem by executing:

```shell
gem install sheets_v4
```

## Examples

Many examples can be found in the `examples` directory of this project. The examples
have [a README of their own](https://github.com/main-branch/sheets_v4/tree/reformat_examples/examples)
which describes each example.

Prior to running an example, clone this project and run `bundle install` in the
project's root working directory.

Run an example using `bundle exec`. For example, to run the `set_background_color1`
example:

```shell
bundle exec examples/set_background_color1
```

## Important links for programming Google Sheets

### SheetsV4 documenation

This Gem's YARD documentation is hosted on [rubydoc.info]https://rubydoc.info/gems/sheets_v4/.

### General API documentation

* [Google Sheets API Overview](https://developers.google.com/sheets/api)
* [Google Sheets API Reference](https://developers.google.com/sheets/api/reference/rest)
* [Batch Update Requests](https://developers.google.com/sheets/api/reference/rest/v4/spreadsheets/request)
* [Discovery Document for the Sheets API](https://sheets.googleapis.com/$discovery/rest?version=v4)

### Ruby implementation of the Sheets API

* [SheetsService Class](https://github.com/googleapis/google-api-ruby-client/blob/main/generated/google-apis-sheets_v4/lib/google/apis/sheets_v4/service.rb)
* [All Other Sheets Classes](https://github.com/googleapis/google-api-ruby-client/blob/main/generated/google-apis-sheets_v4/lib/google/apis/sheets_v4/classes.rb)

### Other links

* [Apps Script for Sheets](https://developers.google.com/apps-script/guides/sheets)

## Getting started

In order to use this gem, you will need to obtain a Google API service account
credential following the instructions below.

### Create a Google Cloud project

Create a Google Cloud project using [these directions](https://developers.google.com/workspace/guides/create-project).

### Enable the APIs you want to use

Enable the Sheets API for this project using [these directions](https://developers.google.com/workspace/guides/enable-apis).
Optionally, enable the Drive API since you may need it to create a spreadsheet.

### Download a Google API credential file

Create a service account and download a credential file using [these directions](https://developers.google.com/workspace/guides/create-credentials#service-account).

You can store the download credential files anywhere on your system.
The recommended location is `~/.google-api-credential.json` since this is default
credential file that `SheetsV4.sheets_service` uses.

## Usage

[Detailed API documenation](https://rubydoc.info/gems/sheets_v4/) is hosted on rubygems.org.

### Obtaining an authenticated SheetsService

Typically, to construct an authenticated SheetsService object where the credential
is read from a file, the following code is required:

```Ruby
sheets_service = Google::Apis::SheetsV4::SheetsService.new
credential = File.read(File.expand_path('~/google-api-credential.json')) do |credential_source|
  scopes = Google::Apis::SheetsV4::AUTH_SPREADSHEETS
  options = { json_key_io: credential_source, scope: scopes }
  Google::Auth::DefaultCredentials.make_creds(options).tap(&:fetch_access_token)
end
sheets_service.authorization = credential
```

The `SheetsV4.sheets_service` method simplifies this a bit.

By default, the credential is read from `~/.google-api-credential.json`. In that case,
an authenticated SheetsService object can be obtained with one method call:

```Ruby
sheets_service = SheetsV4.sheets_service
```

If the credential is stored somewhere else, pass the `credential_source` to
`SheetsV4.sheets_service` manually. `credential_source` can be a String:

```Ruby
sheets_service = SheetsV4.sheets_service(credential_source: File.read('credential.json'))
```

an IO object:

```Ruby
sheets_service = File.open('credential.json') do |credential_source|
  SheetsV4.sheets_service(credential_source:)
end
```

or an already constructed `Google::Auth::*` object.

### Building a request

To use the Sheets API, you need to construct JSON formatted requests.

These requests can be constructed using two different methods:
1. constructing requests using `Google::Apis::SheetsV4::*` objects or
2. constructing requests using hashes

The following two sections show how each method can be used to construct
a request to update a row of values in a sheet.

For these two examples, values in the `values` array will be written to the
sheet whose ID is 0. The values will be written one per row starting at cell A1.

```Ruby
values = %w[one two three four] # 'one' goes in A1, 'two' goes in A2, etc.
```

The method `SheetsService#batch_update_spreadsheet` will be used to write the values. This
method takes a `batch_update_spreadsheet_request` object with a `update_cells` request
that defines the update to perform.

#### Method 1: constructing requests using `Google::Apis::SheetsV4::*` objects

When using this method, keep the Ruby source file containing the SheetsService class
([google/apis/sheets_v4/service.rb](https://github.com/googleapis/google-api-ruby-client/blob/main/generated/google-apis-sheets_v4/lib/google/apis/sheets_v4/service.rb))
and the Ruby source file containing the defitions of the request & data classes
([lib/google/apis/sheets_v4/classes.rb](https://github.com/googleapis/google-api-ruby-client/blob/main/generated/google-apis-sheets_v4/lib/google/apis/sheets_v4/classes.rb))
open for easy searching. These files will give you all the information you need
to construct valid requests.

Here is the example constructing requests using `Google::Apis::SheetsV4::*` objects

```Ruby
def values = %w[one two three four]

def row_data(value)
  Google::Apis::SheetsV4::RowData.new(
    values: [
      Google::Apis::SheetsV4::CellData.new(
        user_entered_value:
          Google::Apis::SheetsV4::ExtendedValue.new(string_value: value.to_s)
      )
    ]
  )
end

def rows
  values.map { |value| row_data(value) }
end

def write_values_request
  fields = 'user_entered_value'
  start = Google::Apis::SheetsV4::GridCoordinate.new(
    sheet_id: 0, row_index: 0, column_index: 0
  )
  Google::Apis::SheetsV4::Request.new(
    update_cells: Google::Apis::SheetsV4::UpdateCellsRequest.new(rows:, fields:, start:)
  )
end

requests = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(requests: [write_values_request])

spreadsheet_id = '18FAcgotK7nDfLTOTQuGCIjKwxkJMAguhn1OVzpFFgWY'
SheetsV4.sheets_service.batch_update_spreadsheet(spreadsheet_id, requests)
```

#### Method 2: constructing requests using hashes

When constructing requests using this method, keep the [Google Sheets Rest API Reference](https://developers.google.com/sheets/api/reference/rest)
documentation open. In particular, [the Batch Update Requests page](https://developers.google.com/sheets/api/reference/rest/v4/spreadsheets/request#cutpasterequest)
is particularly useful for building spreadsheet batch update requests.

One caveat to keep in mind is that the Rest API documents object properties using
Camel case BUT the Ruby API requires snake case.

For instance, the Rest API documents the properties for a grid coordinate to be
"sheetId", "rowIndex", and "columnIndex". However, in the Ruby API, you should
construct this object using snake case:

```Ruby
grid_coordinate = { sheet_id: 0, row_index: 0, column_index: 0 }
```

Here is the example constructing requests using hashes:

```Ruby
def values = %w[one two three four]

def rows
  values.map do |value|
    { values: [{ user_entered_value: { string_value: value } }] }
  end
end

def write_values_request
  fields = 'user_entered_value'
  start = { sheet_id: 0, row_index: 0, column_index: 0 }
  { update_cells: { rows:, fields:, start: } }
end

requests = { requests: [write_values_request] }

spreadsheet_id = '18FAcgotK7nDfLTOTQuGCIjKwxkJMAguhn1OVzpFFgWY'
response = SheetsV4.sheets_service.batch_update_spreadsheet(spreadsheet_id, requests)
```

#### Which method should be used?

Either method will do the same job. I prefer "Method 2: constructing requests using
hashes" because my code is more concise and easy to read.

While either method can produce a malformed request, "Method 2" is more likely to
result in malformed requests. Unfortunately, when given a malformed request, the
Google Sheets API will do one of following depending on the nature of the problem:

1. Raise a `Google::Apis::ClientError` with some additional information
2. Raise a `Google::Apis::ClientError` with no additional information (this the most
   common result)
3. Not return an error with some of the batch requests not having the expected outcome

Luckily, you can validate that requests are valid and identifies precisely where
the request objects do not conform to the API description using the DiscoveryV1 API.
That is the subject of the next section [Validating requests](#validating-requests).

### Validating requests

Use the [DiscoveryV1 API](https://github.com/main-branch/discovery_v1)
can be used to validate request object prior to using them in the Google Sheets API.

In this API, [`DiscoveryV1.validate_object`](https://rubydoc.info/gems/discovery_v1/DiscoveryV1#validate_object-class_method)
validates a request object for a given schema. This method takes a `schema_name`
and an `object` to validate. Valid schemas names for an API can be listed using
[`SheetsV4.api_object_schema_names`](https://rubydoc.info/gems/sheets_v4/SheetsV4#api_object_schema_names-class_method).

`validate_object` will either return `true` if `object` conforms to the schema OR it
will raise a RuntimeError noting where the object structure did not conform to
the schema.

In the previous examples (see [Building a request](#building-a-request)), the
following lines can be inserted after the `requests =  ...` line to validate the
request:

```Ruby
require 'discovery_v1'
discovery_service = DiscoveryV1.discovery_service
rest_description = discovery_service.get_rest_api('sheets', 'v4')
schema_name = 'batch_update_spreadsheet_request'
object = requests
begin
  DiscoveryV1.validate_object(rest_description:, schema_name:, object:)
  puts 'BatchUpdateSpreadsheetRequest object is valid'
rescue RuntimeError => e
  puts e.message
end
```

### Google Extensions

The `SheetsV4::GoogleExtensions` module provides extensions to the `Google::Apis::SheetsV4`
classes to simplify use of the SheetsV4 API.

These extensions are not loaded by default and are not required to use other parts
of this Gem. To enable these extension, you must:

```Ruby
require 'sheets_v4/google_extensions'
```

#### SheetsService Extensions

Functionality is added to `get_spreadsheet` to set the `sheets_service` attribute on
the returned spreadsheet and set the `sheets_service` and `spreadsheet` attributes
on the sheets contained in the spreadsheet.

This can simplify complex spreadsheet updates because you won't have to pass a
sheets_service, spreadsheet, and sheet objects separately.

#### Spreadsheet Extensions

The `sheets_service` attribute is added and is set by `SheetsService#get_spreadsheet`.

Convenience methods for getting sheets within the spreadsheet are added:

* `sheet(id_or_title)`: returns the sheet matching the id or title given
* `sheet_id(title)`: returns the ID  for the sheet matching the title given
* `each_sheet(ids_or_titles)`: enumerates the sheets within a spreadsheet matching
  the given IDs or titles.

#### Sheet Extensions

The `sheets_service` and `spreadsheet` attributes are added. Both are set when the
sheet's spreadsheet is loaded by `SheetsService#get_spreadsheet`.

### Working with dates and times

Google Sheets, similar to other spreadsheet programs, stores dates and date-time
values as numbers. This system makes it easier to perform calculations with
dates and times.

This gem provides two sets of equavalent conversion methods. The first set is defined
as class methods on the `SheetsV4` class.

* `SheetsV4.date_to_gs(date)` returns a numeric cell value
* `SheetsV4.gs_to_date(cell_value)` returns a Date object
* `SheetsV4.datetime_to_gs(datetime)` returns a numeric cell value
* `SheetsV4.gs_to_datetime(cell_value)` returns a DateTime object

In order to convert to and from spreadsheet values, the spreadsheet timezone must
be known. A spreadsheet's timezone is found in the Google Sheets spreadsheet object's
properties:

```Ruby
SheetsV4.default_spreadsheet_tz = spreadsheet.properties.time_zone
```

If a time zone is not set using `SheetsV4.default_spreadsheet_tz`, a RuntimeError
will be raised when any of the above methods are used.

Here is an example of how the timezone can change the values fetched from the
spreadsheet:

```Ruby
cell_value = 44333.191666666666

SheetsV4.default_spreadsheet_tz = 'America/New_York'
datetime = SheetsV4.gs_to_datetime(cell_value) #=> Mon, 17 May 2021 04:36:00 -0400
datetime.utc #=> 2021-05-17 08:36:00 UTC

SheetsV4.default_spreadsheet_tz = 'America/Los_Angeles'
datetime = SheetsV4.gs_to_datetime(cell_value) #=> Mon, 17 May 2021 04:36:00 -0700
datetime.utc #=> 2021-05-17 11:36:00 UTC
```

Valid time zone names are those listed in one of these two sources:

* `ActiveSupport::TimeZone.all.map { |tz| tz.tzinfo.name }`
* `ActiveSupport::TimeZone.all.map(&:name)`

The `SheetsV4` methods works well if the spreadsheet timezone is constant through
the run of the program. If this is not the case -- for instance when working with
multiple spreadsheets whose timezones may be different -- then use
`SheetsV4::ConvertDatesAndTimes`.

Each instance of `SheetsV4::ConvertDatesAndTimes` has it's own spreadsheet timezone
used in the conversions. Instance methods for this class are the same as the
date conversion methods on the SheetsV4 class.

Example:

```Ruby
cell_value = 44333.191666666666
converter = SheetsV4::ConvertDatesAndTimes.new('America/Los_Angeles')
datetime = SheetsV4.gs_to_datetime(cell_value) #=> Mon, 17 May 2021 04:36:00 -0700
datetime.utc #=> 2021-05-17 11:36:00 UTC
```

### Working with colors

Color objects (with appropriate :red, :green, :blue values) can be retrieved by name
using `SheetsV4.color(:black)` or `SheetsV4::Color.black` (these are equivalent).

Color names can be listed using `SheetsV4.color_names`.

The color object returned is a Hash as follows:

```Ruby
SheetsV4::Color.black #=> {:red=>0.0, :green=>0.0, :blue=>0.0}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies and then, run
`rake` to run the tests, static analysis, etc. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push git
commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on [the main-branch/sheets_v4 GitHub project](https://github.com/main-branch/sheets_v4).

### Commit message guidelines

All commit messages must follow the [Conventional Commits
standard](https://www.conventionalcommits.org/en/v1.0.0/). This helps us maintain a
clear and structured commit history, automate versioning, and generate changelogs
effectively.

To ensure compliance, this project includes:

* A git commit-msg hook that validates your commit messages before they are accepted.

  To activate the hook, you must have node installed and run `npm install`.

* A GitHub Actions workflow that will enforce the Conventional Commit standard as
  part of the continuous integration pipeline.

  Any commit message that does not conform to the Conventional Commits standard will
  cause the workflow to fail and not allow the PR to be merged.

### Pull request guidelines

All pull requests must be merged using rebase merges. This ensures that commit
messages from the feature branch are preserved in the release branch, keeping the
history clean and meaningful.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
