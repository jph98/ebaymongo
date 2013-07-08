#!/usr/bin/env ruby

require 'rubygems'
require 'mongo_mapper'

MongoMapper.connection = Mongo::Connection.from_uri('mongodb://localhost:27017')
MongoMapper.database = "myebayitems" 

class Item
	include MongoMapper::Document

	key :name, String
	key :location, String
	key :price, Float
end

# Cleanup previous entries
Item.destroy_all()

Item.new(
	:name => "Megaman X",
	:platform => "Super NES",
	:location => "Bath",
	:price => 11.50).save()

Item.new(
	:name => "Chuckie Egg II",
	:platform => "ZX Spectrum",
	:location => "Bristol",
	:price => 5.50).save()

Item.new(
	:name => "Rescue from Fractalus",
	:platform => "Commodore 64",
	:location => "Chippenham",
	:price => 2.50).save()

puts "Saved items"

# Retrive all the items (can also use find_each)
items = Item.all()
puts "\n(all) Found #{items.size()} items:"
items.each do |i|
	puts i.to_mongo()
end

# Retrieve using a simple price query
items = Item.all( :price => {:$gt => 5} )
puts "\n(by price) Found #{items.size()} items > 5.00:"
items.each do |i|
	puts i.to_mongo()
end

