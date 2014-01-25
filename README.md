# Filament

Simple continuous integration for iOS projects.

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

## Architecture

Mac app running on server.

Add a job by giving it a git URL and branch name.

Project at that git URL/branch has a .filament config file in JSON format:

	{
		"workspace": "BasicApp.xcworkspace",
		"scheme": "BasicApp"
	}

This will build the project with xctool.

	xctool.sh -workspace BasicApp.xcworkspace -scheme BasicApp -sdk iphonesimulator -reporter json-stream:json-stream.json -reporter pretty -reporter json-compilation-database:json-compilation-database.json clean build analyze test

Warnings: 5
Errors: 3
Analyser errors: 4
Tests failed: 1
Total tests: 180
