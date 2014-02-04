#!/usr/bin/env ruby

require 'mongo_mapper'

MongoMapper.connection = Mongo::Connection.from_uri('mongodb://localhost:27017')
MongoMapper.database = "myebayitems"

# Retrieve all the items (can also use find_each)
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

item = Item.find_by_price(2.50)
puts "Dynamic finder #{item.to_mongo()}"