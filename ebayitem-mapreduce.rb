#!/usr/bin/env ruby

require 'mongo_mapper'

MongoMapper.connection = Mongo::Connection.from_uri("mongodb://localhost:27017")
MongoMapper.database = "myebayitems"

class Item
	include MongoMapper::Document

	key :name, String
	key :description, String
	key :location, String
	key :price, Float

end

# Create a class to encapsulate the map, reduce operation and the query
class ItemStats

	def self.item_counts_by_name
	    results = []
	    
	    counts_cursor = ItemStats.build.find()

	    # map_hash is an OrderedHash that looks like # {"_id"=>"Ayn Rand", "value"=>2.0}
	    counts_cursor.each_with_index do |map_hash, i|
	      results << map_hash
	      puts "#{i+1}: #{map_hash["_id"]}: #{map_hash["value"]}"
	    end
	    # An array of map_hash results for each unique key
	    results
	  end

	def self.map
	    <<-MAP
		function() {
		  emit(this.name, this.price);
		}
	    MAP
	 end

	def self.reduce
	    <<-REDUCE
		function(key, values) {
		  var name_count = 0;
		  for (var i in values) {
		    name_count += 1;
		  }
		  return name_count;
		}
	    REDUCE
  	end

  	def self.build
	    Item.collection.map_reduce(map, reduce,  :out => "mr_results")
	end
end

# Cleanup previous entries
Item.destroy_all()

Item.new(:name => "Megaman X",:description => "Mega man x SNES game very rare Fully working",:platform => "Super NES",:location => "Bath",:price => 11.50).save()
Item.new(:name => "Megaman X",:description => "Mega man x SNES game very rare Fully working",:platform => "Super NES",:location => "Bath",:price => 2.00).save()
Item.new(:name => "Megaman X",:description => "Mega man x SNES game very rare Fully working",:platform => "Super NES",:location => "Bath",:price => 4.50).save()
Item.new(:name => "Megaman X",:description => "Mega man x SNES game very rare Fully working",:platform => "Super NES",:location => "Bath",:price => 6.00).save()
Item.new(:name => "Megaman X",:description => "Mega man x SNES game very rare Fully working",:platform => "Super NES",:location => "Bath",:price => 8.60).save()

Item.new(:name => "Chuckie Egg II",:description => "Chuckie Egg II for the ZX Spectrum.  Good condition.",:platform => "ZX Spectrum",:location => "Bristol",:price => 5.50).save()
Item.new(:name => "Chuckie Egg II",:description => "Chuckie Egg II for the ZX Spectrum.  Good condition.",:platform => "ZX Spectrum",:location => "Bristol",:price => 2.50).save()
Item.new(:name => "Chuckie Egg II",:description => "Chuckie Egg II for the ZX Spectrum.  Good condition.",:platform => "ZX Spectrum",:location => "Bristol",:price => 3.00).save()
Item.new(:name => "Chuckie Egg II",:description => "Chuckie Egg II for the ZX Spectrum.  Good condition.",:platform => "ZX Spectrum",:location => "Bristol",:price => 5.40).save()
Item.new(:name => "Chuckie Egg II",:description => "Chuckie Egg II for the ZX Spectrum.  Good condition.",:platform => "ZX Spectrum",:location => "Bristol",:price => 7.70).save()

Item.new(:name => "Rescue from Fractalus",:description => "Rescue on Fractalus for the 48/128k Sinclair ZX Spectrum.  Very good condition - some controls have noted inside the sleeve in biro.",:platform => "Commodore 64",:location => "Chippenham",:price => 4.50).save()
Item.new(:name => "Rescue from Fractalus",:description => "Rescue on Fractalus for the 48/128k Sinclair ZX Spectrum.  Very good condition - some controls have noted inside the sleeve in biro.",:platform => "Commodore 64",:location => "Chippenham",:price => 6.50).save()
Item.new(:name => "Rescue from Fractalus",:description => "Rescue on Fractalus for the 48/128k Sinclair ZX Spectrum.  Very good condition - some controls have noted inside the sleeve in biro.",:platform => "Commodore 64",:location => "Chippenham",:price => 8.50).save()
Item.new(:name => "Rescue from Fractalus",:description => "Rescue on Fractalus for the 48/128k Sinclair ZX Spectrum.  Very good condition - some controls have noted inside the sleeve in biro.",:platform => "Commodore 64",:location => "Chippenham",:price => 9.50).save()

ItemStats.item_counts_by_name()