#!/bin/env ruby

if ARGV.length != 1
  puts "Usage: ruby build.sh <netrunnerdb deck url>"
  exit(1)
end

# https://netrunnerdb.com/en/decklist/40010/earth-s-greatest-mum-high-win-rate-

require 'uri'

deck_id = URI(ARGV[0]).path.split('/')[3]

url = "https://netrunnerdb.com/api/2.0/public/decklist/#{deck_id}"

raw = `curl #{url}`
# puts raw

require 'json'

json = JSON.parse(raw)

card_to_freq = json['data'][0]['cards']

`mkdir cards`

card_to_freq.each do |c, freq|
  next if File.exist?("cards/#{c}.png")

  url = "https://netrunnerdb.com/card_image/#{c}.png"
  `curl #{url} --output cards/#{c}.png`
end

`mkdir decks`

File.open("decks/#{deck_id}.html", "w") do |f|
  f.puts "<html>"
  f.puts "<head>"
  f.puts "<style>"
  f.puts "@page { size: letter; margin-left: 5pt; margin-right: 5pt; }"
  f.puts "img { width: 180pt; }"
  f.puts "</style>"
  f.puts "</head>"
  f.puts "<body>"

  card_to_freq.each do |c, freq|
    freq.times do
      f.puts "<img src='../cards/#{c}.png'>"
    end
  end

  f.puts "</body>"
  f.puts "</html>"
end

`open decks/#{deck_id}.html`