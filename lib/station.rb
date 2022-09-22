require_relative 'metaprogramming/validation'

class Station
  include Validation

  attr_reader :errors, :name

  validate :name, :presence
  validate :name, :format, /\A[[:upper:]][[:lower:]][-\w]+\z/

  def initialize(name)
    @name = name
    @trains = []
  end

  def take_train(train)
    @trains.push(train)
  end

  def take_away_train(train)
    @trains.delete(train)
  end

  def to_s
    result = "Cтанция '#{name}':\n"
    result +=
      if @trains.size > 0
        'Поезда на станции: ' +
          @trains.map { |train| "номер '#{train.number}', вагонов: #{train.wagons_count}" }.join('; ')
      else
        'На станции нет поездов'
      end
  end
end
