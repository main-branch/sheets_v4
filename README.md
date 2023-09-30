# SheetsV4

[![Gem Version](https://badge.fury.io/rb/sheets_v4.svg)](https://badge.fury.io/rb/sheets_v4)
[![Documentation](https://img.shields.io/badge/Documentation-Latest-green)](https://rubydoc.info/gems/sheets_v4/)
[![Change Log](https://img.shields.io/badge/CHANGELOG-Latest-green)](https://rubydoc.info/gems/sheets_v4/file/CHANGELOG.md)
[![Build Status](https://github.com/main-branch/sheets_v4/workflows/CI%20Build/badge.svg?branch=main)](https://github.com/main-branch/sheets_v4/actions?query=workflow%3ACI%20Build)
[![Maintainability](https://api.codeclimate.com/v1/badges/aeebc016487c5cad881e/maintainability)](https://codeclimate.com/github/main-branch/sheets_v4/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/aeebc016487c5cad881e/test_coverage)](https://codeclimate.com/github/main-branch/sheets_v4/test_coverage)

Unofficial helpers for the Google Sheets V4 API

* [Important Links for Programming Google Sheets](#important-links-for-programming-google-sheets)
  * [General API Documentation](#general-api-documentation)
  * [Ruby Implementation of the Sheets API](#ruby-implementation-of-the-sheets-api)
  * [Other Links](#other-links)
* [Installation](#installation)
* [Usage](#usage)
  * [Colors](#colors)
* [Development](#development)
* [Creating a Google API Service Account](#creating-a-google-api-service-account)
* [Contributing](#contributing)
* [License](#license)

## Important Links for Programming Google Sheets

### General API Documentation

* [Google Sheets API Overview](https://developers.google.com/sheets/api)
* [Google Sheets API Reference](https://developers.google.com/sheets/api/reference/rest)
* [Batch Update Requests](https://developers.google.com/sheets/api/reference/rest/v4/spreadsheets/request)

### Ruby Implementation of the Sheets API

* [SheetsService Class](https://github.com/googleapis/google-api-ruby-client/blob/main/generated/google-apis-sheets_v4/lib/google/apis/sheets_v4/service.rb)
* [All Other Sheets Classes](https://github.com/googleapis/google-api-ruby-client/blob/main/generated/google-apis-sheets_v4/lib/google/apis/sheets_v4/classes.rb)

### Other Links

* [Apps Script for Sheets](https://developers.google.com/apps-script/guides/sheets)

## Installation

Install the gem and add to the application's Gemfile by executing:

```shell
bundle add sheets_v4
```

If bundler is not being used to manage dependencies, install the gem by executing:

```shell
gem install sheets_v4
```

## Usage

[Detailed API documenation](https://rubydoc.info/gems/sheets_v4/) is hosted on rubygems.org.

### Colors

Color objects (with appropriate :red, :green, :blue values) can be retrieved by name
using `SheetsV4.color(:black)` or `SheetsV4::Color.black` (these are equivalent).

Color names can be listed using `SheetsV4.color_names`.

The color object returned is a Hash as follows:

```Ruby
SheetsV4::Color.black #=> {:red=>0.0, :green=>0.0, :blue=>0.0}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push git
commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Creating a Google API Service Account


## Contributing

Bug reports and pull requests are welcome on [the main-branch/sheets_v4 GitHub project](https://github.com/main-branch/sheets_v4).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
