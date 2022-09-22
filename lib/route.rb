require_relative 'metaprogramming/validation'
require_relative 'station'

class Route
  include Validation

  attr_reader :errors, :number, :start_station, :end_station

  validate :number, :presence
  validate :number, :format, /\A[A-Z]{4,}-\d{2,}\z/
  validate :start_station, :presence
  validate :start_station, :type, ::Station
  validate :end_station, :presence
  validate :end_station, :type, ::Station
  validate :start_station, :not_equal, :end_station

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
