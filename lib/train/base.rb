require_relative '../modules/instanceable'
require_relative '../modules/train_wagon_extendable'

module Train
  class Base
    include Instanceable
    include TrainWagonExtendable

    attr_reader :speed, :wagons_counter, :current_station

    def initialize(number)
      @number = number
      @wagons = []
      @speed = 0
      register_instance
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

    def next_station
      return if current_station == @route.end_station
      actual_route[actual_route.index(current_station) + 1]
    end

    def prev_station
      return if current_station == @route.start_station
      actual_route[actual_route.index(current_station) - 1]
    end

    def go_to_next_station
      go_to_station(next_station)
    end

    def go_to_prev_station
      go_to_station(prev_station)
    end

    def attach_wagon(wagon)
      @wagons.push(wagon) if is_stopped?
    end

    def dettach_wagon(wagon)
      @wagons.delete(wagon) if is_stopped?
    end

    def to_s
      result = " поезд номер '#{number}'.\n  Маршрут "
      result += @route ? "следования '#{@route.number}'" : 'не назначен'
      result += ",\n  "
      result += @wagons.any? ? "Вагоны: #{@wagons.map { |w| "'#{w.number}'" }.join(', ')}." : 'Вагонов нет.'
    end


    # def find

    # end

    private

    def is_stopped?
      speed == 0
    end

    def actual_route
      @route.get_route
    end

    def go_to_station(new_station)
      return if new_station.nil?
      current_station.take_away(self) if current_station
      @current_station = new_station
      current_station.take(self)
    end
  end
end
