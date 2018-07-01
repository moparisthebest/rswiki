#!/bin/sh
exec find ./ -iname "*.mediawiki" -type f -exec bash -c 'pandoc "${0}" -o "${0%.mediawiki}.md" && rm "${0}"' {} \;
