require_relative '../train_wagon_extendable'
require_relative '../metaprogramming/validation'

module Wagon
  class Base
    include TrainWagonExtendable
    include Validation

    validate :number, :presence
    validate :number, :format, /\A[A-Z]{2,}-\d{3,}\z/

    def initialize(number)
      @number = number
    end
  end
end
