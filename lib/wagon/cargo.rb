require_relative 'base'

module Wagon
  class Cargo < Base
    def initialize(number)
      @type = TYPES[0]
      super(number)
    end

    def to_s
      "#{@number} (грузовой)"
    end
  end
end
