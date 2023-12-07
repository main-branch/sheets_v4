# Google Sheets Examples

* [✅︎ Creating a Google API service account](#︎-creating-a-google-api-service-account)
* [✅︎ Create a SheetsService instance](#︎-create-a-sheetsservice-instance)
* [✅︎ Set background color](#︎-set-background-color)
* [Creating Google Sheets files](#creating-google-sheets-files)
* [Writing data to a sheet](#writing-data-to-a-sheet)
* [Reading data from a sheet](#reading-data-from-a-sheet)
* [Data formatting basics](#data-formatting-basics)
* [Creating charts](#creating-charts)
* [Data validation](#data-validation)
* [Cut, copy, and paste](#cut-copy-and-paste)
* [Duplicate sheets](#duplicate-sheets)
* [List sheets in a spreadsheet](#list-sheets-in-a-spreadsheet)
* [Set column width and row height](#set-column-width-and-row-height)
* [Append rows and columns](#append-rows-and-columns)
* [Delete rows and columns](#delete-rows-and-columns)
* [Insert rows and columns](#insert-rows-and-columns)
* [Move rows and columns](#move-rows-and-columns)
* [Clear data](#clear-data)
* [Add and delete sheets](#add-and-delete-sheets)
* [Copy sheet from one spreadsheet to another](#copy-sheet-from-one-spreadsheet-to-another)
* [Add a new sheet to an existing spreadsheet](#add-a-new-sheet-to-an-existing-spreadsheet)
* [Export a sheet to a CSV file](#export-a-sheet-to-a-csv-file)
* [Sort sheets](#sort-sheets)
* [Add calculated fields into a pivot table](#add-calculated-fields-into-a-pivot-table)
* [Named ranges](#named-ranges)
* [Create a pivot table](#create-a-pivot-table)
* [Calculated pivot fields](#calculated-pivot-fields)
* [Delete a pivot table](#delete-a-pivot-table)
* [Add pivot fields](#add-pivot-fields)
* [Add pivot filters](#add-pivot-filters)
* [Collapse/expand pivot table groups](#collapseexpand-pivot-table-groups)
* [Extract pivot table metadata](#extract-pivot-table-metadata)
* [Filter views](#filter-views)
* [Locate the last row in a column](#locate-the-last-row-in-a-column)
* [Autofill](#autofill)
* [Rename a sheet](#rename-a-sheet)
* [Find and replace](#find-and-replace)
* [Add and delete sheets](#add-and-delete-sheets-1)
* [Sum across sheets](#sum-across-sheets)
* [Freeze rows / columns](#freeze-rows--columns)
* [Protected ranges](#protected-ranges)
* [Resize a sheet](#resize-a-sheet)
* [Retrying on error](#retrying-on-error)
* [Set a custom datetime or decimal format for a range](#set-a-custom-datetime-or-decimal-format-for-a-range)

Annotated examples written in Ruby.

Checked (✅︎) topics are completed. Topics without a check still need to be added.

### ✅︎ Creating a Google API service account

<sup>[1](https://www.youtube.com/watch?v=sAgWCbGMzTo&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=1)</sup>

<sup>[2](https://www.youtube.com/watch?v=sVURhxyc6jE&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=43)</sup>

See the [Getting started](https://github.com/main-branch/sheets_v4#getting-started)
section in the project README.md

### ✅︎ Create a SheetsService instance

See [Obtaining an authenticated SheetsService](https://github.com/main-branch/sheets_v4#obtaining-an-authenticated-sheetsservice)
section in the project README.md

### ✅︎ Set background color

[examples/set_background_color1](https://github.com/main-branch/sheets_v4/blob/main/examples/set_background_color1):
set background colors building requests using `Google::Apis::SheetsV4::*` objects.
See the [Building a request](https://github.com/main-branch/sheets_v4/blob/main/README.md#building-a-request)
section in the project README.md.

[examples/set_background_color2](https://github.com/main-branch/sheets_v4/blob/main/examples/set_background_color2):
set background colors building requests using `Hash` objects.
See the [Building a request](https://github.com/main-branch/sheets_v4/blob/main/README.md#building-a-request)
section in the project README.md.

### Creating Google Sheets files

<sup>[1](https://www.youtube.com/watch?v=JRUxeQ6ZCy0&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=2)</sup>

### Writing data to a sheet

<sup>[1](https://www.youtube.com/watch?v=YF7Ad-7pvks&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=3)</sup>

### Reading data from a sheet

<sup>[1](https://www.youtube.com/watch?v=gkglr8GID5E&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=4)</sup>

Reading data

Reading formulas

### Data formatting basics

<sup>[1](https://www.youtube.com/watch?v=R4EN3iPRris&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=5)</sup>

### Creating charts

<sup>[1](https://www.youtube.com/watch?v=xt3p5I8mNWE&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=6)</sup>

### Data validation

<sup>[1](https://www.youtube.com/watch?v=n_Z2565gu6Y&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=7)</sup>

### Cut, copy, and paste

<sup>[1](https://www.youtube.com/watch?v=r8GWH2E_ehw&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=8)</sup>

### Duplicate sheets

<sup>[1](https://www.youtube.com/watch?v=BgQoPcoOiGY&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=9)</sup>

### List sheets in a spreadsheet

<sup>[1](https://www.youtube.com/watch?v=BgQoPcoOiGY&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=9)</sup>

### Set column width and row height

<sup>[1](https://www.youtube.com/watch?v=H3uMEaPqTVE&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=11)</sup>

### Append rows and columns

<sup>[1](https://www.youtube.com/watch?v=txfiwEjb7sk&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=12)</sup>

### Delete rows and columns

<sup>[1](https://www.youtube.com/watch?v=w1jrCxWx7Tc&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=13)</sup>

### Insert rows and columns

<sup>[1](https://www.youtube.com/watch?v=FL7WSsO5EVs&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=14)</sup>

### Move rows and columns

<sup>[1](https://www.youtube.com/watch?v=YHk3305dkOc&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=15)</sup>

### Clear data

<sup>[1](https://www.youtube.com/watch?v=mvbnhfdDrro&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=16)</sup>

### Add and delete sheets

<sup>[1](https://www.youtube.com/watch?v=X9PVQQVoJFc&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=17)</sup>

### Copy sheet from one spreadsheet to another

<sup>[1](https://www.youtube.com/watch?v=aIEM7Ts4n-c&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=18)</sup>

### Add a new sheet to an existing spreadsheet

### Export a sheet to a CSV file

<sup>[1](https://www.youtube.com/watch?v=Dz22fsWsLhI&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=25)</sup>

### Sort sheets

<sup>[1](https://www.youtube.com/watch?v=qbBZX7uBM1M&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=27)</sup>

### Add calculated fields into a pivot table

<sup>[1](https://www.youtube.com/watch?v=VR8zOz5ATLU&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=32)</sup>

### Named ranges

<sup>[1](https://www.youtube.com/watch?v=LTPdfXS_LHA&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=42)</sup>

### Create a pivot table

<sup>[1](https://www.youtube.com/watch?v=preFnuL7ua0&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=28)</sup>

### Calculated pivot fields

<sup>[1](https://www.youtube.com/watch?v=QLssI4uvjk4&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=33)</sup>

### Delete a pivot table

### Add pivot fields

<sup>[1](https://www.youtube.com/watch?v=VR8zOz5ATLU&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=32)</sup>

### Add pivot filters

<sup>[1](https://www.youtube.com/watch?v=EKikw-eIcbY&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=29)</sup>

### Collapse/expand pivot table groups

<sup>[1](https://www.youtube.com/watch?v=-S9bs5-ZJ5E&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=31)</sup>

### Extract pivot table metadata

<sup>[1](https://www.youtube.com/watch?v=H1SGdqbaL4w&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=30)</sup>

### Filter views

<sup>[1](https://www.youtube.com/watch?v=GyRxsSlx0GU&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=34)</sup>

### Locate the last row in a column

<sup>[1](https://www.youtube.com/watch?v=NWWHleJll28&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=35)</sup>

### Autofill

<sup>[1](https://www.youtube.com/watch?v=guHGNmODdpM&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=36)</sup>

### Rename a sheet

<sup>[1](https://www.youtube.com/watch?v=iuiDUJ4NrQI&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=37)</sup>

### Find and replace

<sup>[1](https://www.youtube.com/watch?v=YaFR0bu5CrY&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=39)</sup>

### Add and delete sheets

<sup>[1](https://www.youtube.com/watch?v=gMD4v8F8vlc&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=38)</sup>

### Sum across sheets

<sup>[1](https://www.youtube.com/watch?v=7QNk-MXkPC4&list=PL3JVwFmb_BnSee8RFaRPZ3nykuMRlaQp1&index=44)</sup>

### Freeze rows / columns

### Protected ranges

### Resize a sheet

### Retrying on error

### Set a custom datetime or decimal format for a range

<sup>[1](https://developers.google.com/sheets/api/samples/formatting#set_a_custom_datetime_or_decimal_format_for_a_range)</sup>
