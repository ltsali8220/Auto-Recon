#!/bin/bash

# Check if a query was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <dork_query>"
    exit 1
fi

# Encode the query for the URL
query=$(echo "$1" | sed 's/ /+/g')

# Perform the Google search and save the results to a variable
response=$(curl -s "https://www.google.com/search?q=$query")

# Extract URLs from the response
echo "$response" | grep -oP '(?<=<a href="/url\?q=)(https?://[^&]+)' | sed 's/%3F/?/g' | sed 's/%3D/=/g' | sed 's/%26/&/g'

# Note: Google's search HTML structure can change at any time.
