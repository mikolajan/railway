require_relative 'base'

module Wagon
  class Cargo < Base
    attr_reader :volume, :max_volume

    validate :max_volume, :between, 1..138

    def initialize(number, max_volume)
      @type = TYPES[0]
      @volume = 0
      @max_volume = max_volume
      super(number)
    end

    def take_up_volume(vlm)
      raise "Общий объем не может превышать максимальный объем (#{@max_volume} куб.м)" if @volume + vlm > @max_volume

      @volume += vlm
    end

    def take_down_volume(vlm)
      raise "В данный момент можно выгрузить не более #{@volume}" if (@volume - vlm).negative?

      @volume -= vlm
    end

    def to_s
      "#{@number} (грузовой), занято #{@volume} из #{@max_volume} куб.м"
    end
  end
end
