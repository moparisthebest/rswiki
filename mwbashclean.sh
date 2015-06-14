#!/bin/bash
new_file="$1"

# Fix links: Remove leading :
sed -ri 's/\[\[:([^]]*)\]\]/[[\1]]/g' "$new_file"

# Fix links: Change underscores and colons to spaces where there is a link name
grep -ho '\[\[[^|]*|' "$new_file" | sort | uniq | grep '[_:]' | while read line
do
  sed_line=$(echo "$line" | sed -e 's/\[/\\[/g')
  rep_line=$(echo "$line" | tr ':' ' ' | tr '_' ' ')
  sed -i "s/$sed_line/$rep_line/g" "$new_file"
done

# Fix links: Change colons to spaces where there is no link name
grep -ho '\[\[[^:]*:[^]]*\]\]' "$new_file" | sort | uniq | while read line
do
  sed_line=$(echo "$line" | sed -e 's/\[/\\[/g')
  rep_line=$(echo "$line" | tr ':' ' ')
  sed -i "s/$sed_line/$rep_line/g" "$new_file"
done

# Add categories to packets
echo "$new_file" | grep '^194-' && sed -i '1i [[Category Packet]]\n[[Category Packet 194]]' "$new_file"
echo "$new_file" | grep '^317-' && sed -i '1i [[Category Packet]]\n[[Category Packet 317]]' "$new_file"
echo "$new_file" | grep '^377-' && sed -i '1i [[Category Packet]]\n[[Category Packet 377]]' "$new_file"
echo "$new_file" | grep '^474-' && sed -i '1i [[Category Packet]]\n[[Category Packet 474]]' "$new_file"
echo "$new_file" | grep '^718-' && sed -i '1i [[Category Packet]]\n[[Category Packet 718]]' "$new_file"

# Add category.sh and generate initial category pages
[ ! -e ./category.sh ] && cp ../category.sh ./
./category.sh

#/home/mopar/apps/rbenv/versions/1.9.3-p392/bin/gollum --no-edit