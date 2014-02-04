#!/usr/bin/env ruby

require 'mongo_mapper'
require 'mongomapper_search'

MongoMapper.connection = Mongo::Connection.from_uri('mongodb://localhost:27017')
MongoMapper.database = "myebayitems"

class Item
	include MongoMapper::Document
	include MongoMapper::Search

	key :name, String
	key :description, String
	key :location, String
	key :price, Float

	search_in :description
end

# Cleanup previous entries
Item.destroy_all()

Item.new(
	:name => "Megaman X",
	:description => "Mega man x SNES game very rare Fully working",
	:platform => "Super NES",
	:location => "Bath",
	:price => 11.50).save()

Item.new(
	:name => "Chuckie Egg II",
	:description => "Chuckie Egg II for the Amstrad CPC 464/664/6128.  Good condition.",
	:platform => "ZX Spectrum",
	:location => "Bristol",
	:price => 5.50).save()

Item.new(
	:name => "Rescue from Fractalus",
	:description => "Rescue on Fractalus for the 48/128k Sinclair ZX Spectrum.  Very good condition - some controls have noted inside the sleeve in biro.",
	:platform => "Commodore 64",
	:location => "Chippenham",
	:price => 2.50).save()

puts "Saved items...\n"

puts Item.search("very rare").size