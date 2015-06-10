require 'rubygems'
require 'hpricot'
require 'gollum'
require 'gollum-lib'
require 'optparse'
require 'git'

# from https://gist.github.com/MasterRoot24/ab85de0e7b82ba7f5974
# gem install hpricot gollum git wikicloth

# Parse command line options
# ToDo: Make command line options mandatory
options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: ruby mw-to-gollum.rb --file input-file.xml --directory new.wiki'
  opts.on('-f FILE', '--file FILE', 'MediaWiki export file to import') do |v|
    options[:file] = v
  end
  opts.on('-d DIRECTORY', '--directory DIRECTORY', 'Destination directory in which to create a new Gollum wiki') do |v|
    options[:destination] = v
  end
end.parse!

# Open the input file and create the output repo if it doesn't already exist
file = File.open(options[:file], 'r')
git = Git.init(options[:destination])
wiki = Gollum::Wiki.new(options[:destination])
doc = Hpricot(file)

# Get the Git user name and email
name = git.config('user.name')
email = git.config('user.email')

# Loop through each page in the MediaWiki dump file and create a new page in the Gollum wiki
doc.search('/mediawiki/page').each do |el|
  title = el.at('title').inner_text.tr(":", " ")
  content = el.at('text').inner_text
  commit = { :message => "Import MediaWiki page #{title} into Gollum",
             :name => name,
             :email => email}
  begin
    puts "Writing page #{title}"
    wiki.write_page(title, :mediawiki, content, commit)
  rescue Gollum::DuplicatePageError
    puts "Duplicate #{title}"
  rescue Exception
    puts $!, $@
  end
end

file.close
