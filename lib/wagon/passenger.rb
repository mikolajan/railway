require_relative 'base'

module Wagon
  class Passenger < Base
    def initialize(number)
      @type = TYPES[1]
      super(number)
    end

    def to_s
      "#{@number} (пассажирский)"
    end
  end
end
