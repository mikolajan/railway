require_relative 'base'

module Train
  class Passenger < Base
    def initialize(number)
      @type = TYPES[1]
      super(number)
    end

    def to_s
      'Пассажирский' + super
    end
  end
end
