# VeriJSON

An Objective-C library for verifying JSON against a pattern-based schema.

# Patterns

A pattern describes the expected content of a JSON document. Patterns are themselves valid JSON, and mirror the structure of a matching JSON document by including property names, arrays and objects. Instead of values, a pattern specifies the required type of values.

Allowed types are "number", "string" and "bool". Arrays and objects are represented structurally.

A sample pattern:

    {
        "id": "number",
        "name": "string",
        "price": "number",
        "discounted": "bool",
        "manufacturer": {
            "name": "string"
        },
        "properties": [
            {
                "name": "string",
                "value": "string",
                "tags": [ "string" ]
            }
        ]
    }

A JSON document that successfully matches the pattern:

    {
        "id": 1,
        "price": 12.50,
        "name": "A green door",
        "manufacturer": {
            "name": "ACME"
        },
        "discounted": true,
        "properties": [
            {
                "name": "blah",
                "value": "whatever",
                "tags": [ "great" ]
            },
            {
                "name": "foo",
                "value": "bar",
                "tags": [ ]
            }
        ]
    }

By default, all properties in the pattern are mandatory. JSON documents omitting the properties are not considered to match. However, properties appearing in the JSON document that are not part of the pattern are ignored and considered to match.

# Optional properties

If a property within an object is optional, suffix its name in the pattern with a question mark '?'.

For example:

	{
        "id": "number",
        "name": "string",
        "discounted?": "bool"
    }

All of the following JSON documents successfully match this pattern:

	{
        "id": 4,
        "name": "A green door",
        "discounted": true
    }

	{
        "id": 4,
        "name": "A green door"
    }

	{
        "id": 4,
        "name": "A green door",
        "discounted": null
    }

Note that an optional property may also have a "null" value. This is not true of non-optional properties.

# Regular expressions

The string type may also include an optional regular expression to which a value must conform.

	{
	    "date": "string:\\d{8}"
	}

Matches:

	{
	    "date": "20130101"
	}

Does not match:
	
	{
	    "date": "130101"
	}

# URL types

Links are often expressed in JSON. To verify URLs, use the "url" type.

    {
        "self": "url"
    }

Any non-empty (and non-whitespace) string that can be converted to an NSURL object is considered a match.

Note that this permits URLs other than HTTP URLs, such as FTP URLs, and also relative URLs.

To limit matches to absolute HTTP and HTTPS URLs, append the "http" modifier to the "url" type.

    {
        "self": "url:http"
    }
