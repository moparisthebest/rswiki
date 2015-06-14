#!/bin/bash
echo 'location ^~ /index.php {'
find -type f -name '*.mediawiki' | while read file
do
  title="$(echo "$file" | sed -e 's/^\.\///' -e 's/\.mediawiki$//' -e 's/-/./g')"
  page_name="$(echo "$file" | sed -e 's/^\.\///' -e 's/\.mediawiki$//')"
  [ "$title" == "Home" ] && title='Main_Page'
  #echo "rewrite \"^/index.php?title=:?$title\" \"/$page_name\" permanent;"
  cat <<EOF
  if (\$query_string ~ "title=$title") {
      rewrite ^ "/$page_name?" permanent;
  }
EOF
done
echo '  rewrite ^ "/Home?" permanent;'
echo '}'
exit
location ^~ /index.php {
  if (\$query_string ~ "title=135.Protocol") {
      rewrite ^ "/135-Protocol?" permanent;
  }
  rewrite ^ "/Home?" permanent;
}