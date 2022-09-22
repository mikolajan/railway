require_relative 'base'

module Wagon
  class Passenger < Base
    validate :seats_count, :between, 1..54

    def initialize(number, seats_count)
      @type = TYPES[1]
      @seats_count = seats_count
      @seats = Array.new(seats_count) { false } # false -- свободно, true -- занято
      super(number)
    end

    def seats_count(status = nil)
      return @seats_count if status.nil?

      @seats.count { |i| i == status }
    end

    def take_seat(number)
      raise "Место '#{number}' нельзя занять, максимум мест #{seats_count}" if number > seats_count

      index = number - 1
      raise 'Место уже занято' if @seats[index]

      @seats[index] = true
    end

    def to_s
      "#{@number} (пассажирский), занято мест: #{seats_is_taken_count}, свободно мест #{seats_is_free_count}"
    end

    private

    def seats_is_free_count
      seats_count(false)
    end

    def seats_is_taken_count
      seats_count(true)
    end
  end
end
