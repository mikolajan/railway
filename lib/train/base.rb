require_relative '../train_wagon_extendable'

module Train
  class Base
    include TrainWagonExtendable

    attr_reader :current_station, :speed, :wagons_counter

    def initialize(number)
      @number = number
      @wagons = []
      @speed = 0
    end

    def stop
      @speed = 0
    end

    def speed_up
      @speed += 10
    end

    def set_route(route)
      @route = route
      go_to_station(route.start_station)
    end

    def go_to_next_station
      raise 'Поезд находится на конечной станции маршрута, перемещение невозможно' if next_station.nil?
      go_to_station(next_station)
    end

    def go_to_prev_station
      raise 'Поезд находится на начальной станции маршрута, перемещение невозможно' if prev_station.nil?
      go_to_station(prev_station)
    end

    def attach_wagon(wagon)
      raise 'Поезд должен остановиться' unless is_stopped?
      raise 'Типы поезда и вагона не совпадают' if type != wagon.type
      raise 'Вагон уже прицеплен к поезду' if @wagons.include?(wagon)
      @wagons.push(wagon)
    end

    def dettach_wagon(wagon)
      raise 'Поезд должен остановиться' unless is_stopped?
      raise 'Типы поезда и вагона не совпадают' if type != wagon.type
      raise 'Вагон не прицеплен к поезду' unless @wagons.include?(wagon)
      @wagons.delete(wagon)
    end

    def to_s
      result = " поезд номер '#{number}'.\n  Маршрут "
      result += @route ? "следования '#{@route.number}', текущая станция #{current_station.name}" : 'не назначен'
      result += ",\n  "
      result += @wagons.any? ? "вагоны: #{@wagons.map { |w| "'#{w.number}'" }.join(', ')}" : 'вагонов нет'
    end

    private

    def next_station
      return if current_station == @route.end_station
      actual_route[actual_route.index(current_station) + 1]
    end

    def prev_station
      return if current_station == @route.start_station
      actual_route[actual_route.index(current_station) - 1]
    end

    def is_stopped?
      @speed == 0
    end

    def actual_route
      @route.route
    end

    def go_to_station(new_station)
      return if new_station.nil?
      current_station.take_away_train(self) if current_station
      @current_station = new_station
      current_station.take_train(self)
    end
  end
end
