#!/bin/bash
cd "$(dirname "$0")"

commit(){
  git add .
  git commit -m "$1"
}

rm -rf ./wiki/
ruby mw-to-gollum.rb -f RSWiki-20150610160818.xml -d ./wiki/

cd ./wiki/

cp ../.ruby-version ./
commit 'Added .ruby-version'

cp Main-Page.mediawiki Home.mediawiki
commit 'Copied Main-Page to Home'

sed -ri 's/\[\[:([^]]*)\]\]/[[\1]]/g' *
commit 'Fix links: Remove leading :'

grep -ho '\[\[[^|]*|' * | sort | uniq | grep '[_:]' | while read line
do
  sed_line=$(echo "$line" | sed -e 's/\[/\\[/g')
  rep_line=$(echo "$line" | tr ':' ' ' | tr '_' ' ')
  sed -i "s/$sed_line/$rep_line/g" *
done
commit 'Fix links: Change underscores and colons to spaces where there is a link name'

grep -ho '\[\[[^:]*:[^]]*\]\]' * | sort | uniq | while read line
do
  sed_line=$(echo "$line" | sed -e 's/\[/\\[/g')
  rep_line=$(echo "$line" | tr ':' ' ')
  sed -i "s/$sed_line/$rep_line/g" *
done
commit 'Fix links: Change colons to spaces where there is no link name'

sed -i '1i [[Category Packet]]' 194-* 317-* 377-* 474-* 474-*
sed -i '1i [[Category Packet 194]]' 194-*
sed -i '1i [[Category Packet 317]]' 317-*
sed -i '1i [[Category Packet 377]]' 377-*
sed -i '1i [[Category Packet 474]]' 474-*
sed -i '1i [[Category Packet 718]]' 718-*
commit 'Add categories to packets'

cp ../category.sh ./
./category.sh
commit 'Add category.sh and generate initial category pages'

/home/mopar/apps/rbenv/versions/1.9.3-p392/bin/gollum --no-edit