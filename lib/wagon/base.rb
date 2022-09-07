module Wagon
  class Base
    attr_reader :number, :type

    TYPES = %i(cargo passenger)

    def initialize(number)
      @number = number
    end
  end
end
