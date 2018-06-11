require 'mysql'

class Parcel
	
	def initialize
		@key = 1
		@free_key_slots = {}
		@parcels = {}
	end

	def create_parcel(parcel_code, parcel_weight, slot_numbers, max_key)
	    return puts "Sorry, parcel slot is full" if (@key > max_key && @free_key_slots.empty?)
	    if @free_key_slots.length > 0
	        @parcels[@free_key_slots.first[0]] = { slot_number: @free_key_slots.first[1], parcel_code: parcel_code, parcel_weight: parcel_weight  }
	        puts "Allocated slot number: #{@free_key_slots.first[1]}"
	        @free_key_slots.shift
	    else
	        slot_number = slot_numbers[@key - 1]
	        @parcels[@key] = { slot_number: slot_number, parcel_code: parcel_code, parcel_weight: parcel_weight  }
	        puts "Allocated slot number: #{slot_number}"
	        @key += 1   
	    end
	end

	#Delivering the parcel of the slot
	def delivery(slot_number)
	    key_slots = nil
	    @parcels.select{ |h, k| key_slots = h if k[:slot_number] == slot_number}
	    @parcels.select {|k, v| v[:parcel_code], v[:parcel_weight], v[:slot_number] = nil if v[:slot_number] == slot_number && !v[:parcel_code].nil? }
	    @free_key_slots[key_slots] = slot_number
	    @free_key_slots = Hash[ @free_key_slots.sort_by {|key, value| key} ]
	    puts "slot #{slot_number} is free"
	end

	#Status of the each issued tickets for the parcel.
	def status
	    tickets = @parcels.reject { |k, v| v[:slot_number].nil? }
	    slot_status = tickets.values
	    puts "slot_number  parcel_code  parcel_weight"
	    puts slot_status.collect { |p| "#{p[:slot_number]}            #{p[:parcel_code]}               #{p[:parcel_weight]}" }
	end


	def get(parcel_info, regis_no=nil, weight=nil)
		slots = []
		info = case parcel_info
		when "slot_number_for_registration_number"
			 @parcels.transform_values{|v| slots << v[:slot_number] if v[:parcel_code] == regis_no}
		when "parcel_code_for_parcels_with_weight"
			@parcels.transform_values{|v| slots << v[:parcel_code] if v[:parcel_weight] == weight}
		when "slot_numbers_for_parcels_with_weight"
			@parcels.transform_values{|v| slots << v[:slot_number] if v[:parcel_weight] == weight}
		else
			[] 
		end
		slots.length > 0 ? puts(slots.join(' ')) : puts("Not Found")
		return slots
	end
end