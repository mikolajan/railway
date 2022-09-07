require_relative 'modules/instanceable'

class Route
  attr_reader :number, :start_station, :end_station

  def initialize(number, start_station, end_station)
    @number = number
    @start_station = start_station
    @end_station = end_station
    @intermediate_stations = []
    register_instance
  end

  def find(number)
    instances.find { |item| item.number == number}
  end

  def add_station(station)
    @intermediate_stations.push(station)
  end

  def delete_station(station)
    @intermediate_stations.delete(station)
  end

  def get_route
    [@start_station, *@intermediate_stations, @end_station]
  end

  def to_s
    "Информация о маршруте '#{@number}':\n" \
    "Текущий маршрут следования: #{get_route.map(&:name).join('<--->')}."
  end
end
