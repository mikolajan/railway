# Класс Train (Поезд):
# Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
# Может набирать скорость
# Может возвращать текущую скорость
# Может тормозить (сбрасывать скорость до нуля)
# Может возвращать количество вагонов
# Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов). Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
# Может принимать маршрут следования (объект класса Route). При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
# Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
# Возвращать предыдущую станцию, текущую, следующую, на основе маршрута

module Train
  class Base
    attr_reader :speed, :wagons_counter, :current_station, :type, :number

    TYPES = %i(cargo passenger)

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
