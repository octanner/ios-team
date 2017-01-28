#!/usr/bin/env ruby

# See https://gist.github.com/asabaylus/3071099#gistcomment-1593627
doc = IO.readlines(ARGV[0])
lines = doc.select { |l| l.start_with? "#" }.map do |l|
  indent = l.chomp.gsub(/^# .*/, '* ').gsub(/^## .*/, '    * ').gsub(/^### .*/, '        * ')
  link = l.gsub(/[^a-zA-Z\- ]/u,'').strip().downcase.gsub(' ','-')
  indent + l.chomp.gsub(/^([\# ]*)(.*)$/, '[\2]') + "(##{link})"
end

puts lines.join("\n")