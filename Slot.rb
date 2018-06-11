class Slot
    def self.generate_slot_numbers(number)
        level_one_max_number = (number.to_f/2).ceil
        level_one_slot_numbers = (1..level_one_max_number).to_a
        level_two_min_number = (number.to_f/2).ceil + 1
        level_two_slot_numbers = (level_two_min_number..number).to_a.reverse
        slot_numbers = level_one_slot_numbers.zip(level_two_slot_numbers).flatten.compact
        return  slot_numbers
    end
end