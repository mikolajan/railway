require_relative '../modules/instanceable'
require_relative '../modules/train_wagon_extendable'

module Wagon
  class Base
    include Instanceable
    include TrainWagonExtendable

    def initialize(number)
      @number = number.to_s.upcase
      validate!
      register_instance
    end
  end
end
