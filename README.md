This is the wiki hosted at rswiki.moparisthebest.com, in the wiki git repo.

In this repo you'll find the tools we used for converting from mediawiki to gollum:

* legit_pages.py was written by vortex, and used to scrape and generate legit_pages.txt, which was used to export RSWiki-20150610160818.xml
* mw-to-gollum.rb was slightly modified from here: https://gist.github.com/MasterRoot24/ab85de0e7b82ba7f5974
* mediawiki2gollum.sh uses mw-to-gollum.rb to convert the mediawiki xml, then does various things to clean up all the links and names so they will work
* category.sh scrapes and generates category pages like mediawiki, needs to be ran whenever pages are added to categories

todo: historical versions not converted/saved yet