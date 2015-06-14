This is the wiki hosted at rswiki.moparisthebest.com, in the wiki git repo.

In this repo you'll find the tools we used for converting from mediawiki to gollum:

* legit_pages.py was written by vortex, and used to scrape and generate legit_pages.txt, which was used to export RSWiki-*.xml
* mw2gollum.py converts a mediawiki dump to gollum preserving all contributor names, changes, and timestamps, each change is a seperate commit
* mwbashclean.sh is run before every commit mw2gollum.py makes
* nginxredirect.sh is run to create an nginx config file to redirect old mediawiki titles to the new gollum URLs, generated nginxredirect.conf
* category.sh scrapes and generates category pages like mediawiki, needs to be ran whenever pages are added to categories

Deprecated because they do not preserve history:

* mw-to-gollum.rb was slightly modified from here: https://gist.github.com/MasterRoot24/ab85de0e7b82ba7f5974 DEPRECATED USE mw2gollum.py instead which preserves history!
* mediawiki2gollum.sh uses mw-to-gollum.rb to convert the mediawiki xml, then does various things to clean up all the links and names so they will work DEPRECATED USE mw2gollum.py instead which preserves history!
