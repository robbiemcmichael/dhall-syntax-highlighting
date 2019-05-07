#!/usr/bin/env bash

set -e
set -u

rm -f .gitattributes

curl https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml | yaml2json | jq -r 'keys[]' \
    | while read -r language; do
        echo "$language"

        sanitised_language=$(echo "$language" | sed -Ee 's/[^a-zA-Z0-9+]/-/g')
        echo "$sanitised_language linguist-language=$sanitised_language" >> .gitattributes

        for file in src/*; do
            dir="examples/$(basename "$file")"
            mkdir -p "$dir"
            echo "{- linguist-language=$sanitised_language -}" > "$dir/$sanitised_language"
            cat "$file" >> "$dir/$sanitised_language"
        done
    done
