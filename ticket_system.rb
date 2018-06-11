require_relative 'slot'
require_relative 'parcel'

@key = 1
@max_key = 1
@slot_numbers = []
@parcel = nil

#Creates that will generate parcel slots.
def create_parcel_slot_lot(number)
    @max_key = number
    @slot_numbers = Slot.generate_slot_numbers(number)
    @parcel = Parcel.new
    puts "Created a parcel slot with #{number} slots"
end

#Placing the parcel to the slot
def park(parcel_code, parcel_weight)
    @parcel.create_parcel(parcel_code, parcel_weight, @slot_numbers, @max_key) unless @parcel.nil? 
end

#Delivering the parcel of the slot
def leave_for_delivery(slot_number)
    @parcel.delivery(slot_number)
end

#Status of the each issued tickets for the parcel.
def status
    @parcel.status
end


#Fetches the slot number for the register number
def slot_number_for_registration_number(regis_no)
     @parcel.get("slot_number_for_registration_number", regis_no, nil)
end

#Fetches all the parcel code or registered number for the parcel weight
def parcel_code_for_parcels_with_weight(weight)
    @parcel.get("parcel_code_for_parcels_with_weight", nil, weight)
end

#Fetches all the slot numbers for the parcel weight
def slot_numbers_for_parcels_with_weight(weight)
  @parcel.get("slot_numbers_for_parcels_with_weight", nil, weight)
end

input_filename = ARGV.first

File.open(input_filename, "r") do |f|
    f.each_line do |line|
        string_array = line.split(' ')
        method_name = string_array[0]

        case method_name
        when "create_parcel_slot_lot"
            send(:create_parcel_slot_lot, string_array[1].to_i)
        when "park"
            send(:park, string_array[1], string_array[2])
        when "status"
            send(:status)
        when "leave_for_delivery"
            send(:leave_for_delivery, string_array[1].to_i)
        when "parcel_code_for_parcels_with_weight"
            send(:parcel_code_for_parcels_with_weight, string_array[1])
        when "slot_numbers_for_parcels_with_weight"
            send(:slot_numbers_for_parcels_with_weight, string_array[1])
        when "slot_number_for_registration_number"
            send(:slot_number_for_registration_number, string_array[1])
        end
    end
end

