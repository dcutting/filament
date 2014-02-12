# Filament

Simple continuous integration for iOS projects.

**This is a work in progress and is not ready for use.**

## Features

* Big board display.
* Git branch checkout.
* Warnings/errors.
* Analysis errors.
* Unit tests.
* Acceptance tests.
* OCLint.
* Code coverage.
* Uploads to TestFlight.
* Configured with text files.

## Integrations

Mac app running on server.

Add a job by giving it a git URL and branch name.

Project at that git URL/branch contains a .filament config file in JSON format:

	{
		"workspace": "BasicApp.xcworkspace",
		"scheme": "BasicApp"
	}

This specifies the workspace and scheme used to build the project (using xctool).

	xctool.sh -workspace BasicApp.xcworkspace -scheme BasicApp -sdk iphonesimulator -reporter json-stream:json-stream.json -reporter pretty -reporter json-compilation-database:json-compilation-database.json clean build analyze test

Next is GCovr, which produces code coverage reports from the test phase.

The project is then run through OCLint to flag coding style issues. You can specify limits/values in your .filament file.

This produces an integration result:

	Build errors: 3
	Build warnings: 5
	Tests failed: 1
	Total tests: 180
	Analyser warnings: 4
	Lines covered: 84%
	Style warnings: 2

## Code design

To run a job

	Mark job as in progress
	Clone git repository
	Checkout branch
	Read .filament
		Extract workspace and scheme name
	Run xctool
	Save plain log and json-stream log
	Parse json-stream.json file
		For build phase
			Tally warnings
			Tally errors
		For analysis phase
			Tally errors
		For test phase
			Extract number of failed
			Extract total number
	Write build record for job
		Include plain log
		Write job summary file
			Warnings
			Errors
			Analysis errors
			Tests failed
			Total tests
	Mark job as OK or failed due to error, tests, warnings, analysis (in that order)
	Fire build notification

To serve results

	Read summary of latest build for each job
	For jobs in progress
	Serve as single HTML page

Possible failure reasons:

* invalid URL
* git tool failure
* cannot clone repository/no such branch
* missing configuration
* corrupt configuration
* invalid configuration
* xctool failure
* build
* analyse
* test
* gcovr tool failure
* low code coverage
* oclint tool failure
* bad style
