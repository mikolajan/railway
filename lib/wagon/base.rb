require_relative '../train_wagon_extendable'

module Wagon
  class Base
    include TrainWagonExtendable

    def initialize(number)
      @number = number
    end
  end
end
