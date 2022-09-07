class Route
  attr_reader :number, :start_station, :end_station

  def initialize(number, start_station, end_station)
    @number = number
    @start_station = start_station
    @end_station = end_station
    @intermediate_stations = []
  end

  def add_station(station)
    @intermediate_stations.push(station)
  end

  def delete_station(station)
    raise 'Нельзя удалить начальную станцию' if station == @start_station
    raise 'Нельзя удалить конечную станцию'  if station == @end_station
    raise 'Станция в маршруте отсутсвует' unless @intermediate_stations.include?(station)

    @intermediate_stations.delete(station)
  end

  def route
    [@start_station, *@intermediate_stations, @end_station]
  end

  def to_s
    "Маршрут '#{@number}':\n" \
    "Текущий маршрут следования: #{route.map(&:name).join('<--->')}"
  end
end
