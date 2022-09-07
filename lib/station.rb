class Station
  attr_reader :name

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
    result += if @trains.size > 0
      "На станции #{@trains.size} поездов: #{@trains.map { |train| "'#{train.number}'"}.join(', ')}"
    else
      "На станции нет поездов"
    end
  end
end
