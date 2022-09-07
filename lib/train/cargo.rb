require_relative 'base'

module Train
  class Cargo < Base
    def initialize(number)
      @type = TYPES[0]
      super(number)
    end

    def to_s
      'Грузовой' + super
    end
  end
end
