#!/usr/bin/env ruby

require 'mongo_mapper'

class Item
	include MongoMapper::Document

	key :name, String
	key :description, String
	key :location, String
	key :price, Float
end