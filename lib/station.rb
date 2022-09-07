# Класс Station (Станция):
# Имеет название, которое указывается при ее создании
# Может принимать поезда (по одному за раз)
# Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
# Может возвращать список всех поездов на станции, находящиеся в текущий момент
# Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских

class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
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
