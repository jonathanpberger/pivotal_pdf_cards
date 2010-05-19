require 'rubygems'
require 'fastercsv'
require 'ostruct'
require 'term/ansicolor'
require 'prawn'

require 'stories2cards'

class String; include Term::ANSIColor; end

file = ARGV.first

unless file
  puts "[!] Please provide a path to CSV file"
  exit 1
end

# --- Read the CSV file -------------------------------------------------------

stories = FasterCSV.read(file)
headers = stories.shift

# p headers
# p stories

# --- Hold story in Card class

class Card < OpenStruct
  def type
    @table[:type]
  end
end

# --- Create cards for Features2Cards 
#     [http://github.com/brynary/features2cards/blob/master/lib/features2cards/prawn.rb]

cards = stories.map do |story|
  attrs =  { :title   => story[1]  || '',
             :body   => story[14] || '',
             :type => story[6]  || ''}
  Card.new attrs
end

# p cards

# --- Generate PDF with Prawn

begin

outfile = File.basename(file, ".csv")
Prawn::Document.generate_cards("#{outfile}.pdf", cards)

puts ">>> Generated PDF file in '#{outfile}.pdf' with #{cards.size} stories:\n".black.on_green

cards.each do |card|
  puts "* #{card.title}"
end

rescue Exception
  puts "[!] There was an error while generating the PDF file... What happened was:".white.on_red
  raise
end
