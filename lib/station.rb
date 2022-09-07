require_relative 'modules/instanceable'

class Station
  include Instanceable

  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
    register_instance
  end

  def find(name)
    instances.find { |item| item.name == name}
  end

  def take(train)
    @trains.push(train)
  end

  def take_away(train)
    @trains.delete(train)
  end

  def trains
    @trains.map { |train| train.to_s }
  end

  def trains_count_by_type(type)
    @trains.count { |train| train.type == type }
  end

  def to_s
    result = "Информация о станции '#{name}':\n"
    result += if @trains.size > 0
      "На станции #{@trains.size} поездов: #{@trains.map { |train| "'#{train.number}'"}.join(', ')}"
    else
      "На станции нет поездов."
    end
  end
end
