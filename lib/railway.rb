require_relative 'collection/route'
require_relative 'collection/station'
require_relative 'collection/train'
require_relative 'collection/wagon'

class Railway
  ACTIONS = {
    'Поезд' => [
      'Посмотреть список поездов',
      'Создать пассажирский поезд',
      'Создать грузовой поезд',
      'Прицепить вагон к поезду',
      'Отцепить вагон от поезда',
      'Переместить поезд по маршруту вперед',
      'Переместить поезд по маршруту назад',
      'Назначить маршрут поезду'
    ],
    'Вагон' => [
      'Посмотреть список вагонов',
      'Создать пассажирский вагон',
      'Создать грузовой вагон',
      'Занять место в пассажирском вагоне',
      'Загрузить грузовой вагон'
      # посмотреть свободные места
    ],
    'Станция' => [
      'Посмотреть список станций',
      'Создать станцию'
    ],
    'Маршрут' => [
      'Посмотреть список маршрутов',
      'Создать маршрут',
      'Добавить станцию маршруту',
      'Удалить станцию из маршрута'
    ]
  }

  attr_reader :status

  def initialize
    @routes = Collection::Route.new
    @stations = Collection::Station.new
    @trains = Collection::Train.new
    @wagons = Collection::Wagon.new
    reset_errors_and_status
  end

  def make_action!(action, params)
    reset_errors_and_status

    case action
    when 'Добавить станцию маршруту'
      add_station_to_route(params[:route_number], params[:station_name])
    when 'Загрузить грузовой вагон'
      take_up_volume_in_wagon(params[:wagon_number], params[:volume])
    when 'Занять место в пассажирском вагоне'
      take_seat_in_wagon(params[:wagon_number], params[:place_number])
    when 'Назначить маршрут поезду'
      set_route_for_train(params[:train_number], params[:route_number])
    when 'Отцепить вагон от поезда'
      dettach_wagon_to_train(params[:train_number], params[:wagon_number])
    when 'Прицепить вагон к поезду'
      attach_wagon_to_train(params[:train_number], params[:wagon_number])
    when 'Создать грузовой вагон'
      update_status(@wagons.create_cargo_wagon(params[:wagon_number], params[:total_volume]))
    when 'Создать грузовой поезд'
      update_status(@trains.create_cargo_train(params[:train_number]))
    when 'Создать пассажирский вагон'
      update_status(@wagons.create_passenger_wagon(params[:wagon_number], params[:places_count]))
    when 'Создать пассажирский поезд'
      update_status(@trains.create_passenger_train(params[:train_number]))
    when 'Создать станцию'
      update_status(@stations.create_station(params[:station_name]))
    when 'Создать маршрут'
      create_route(params[:route_number], params[:start_station], params[:end_station])
    when 'Удалить станцию из маршрута'
      delete_station_from_route(params[:route_number], params[:station_name])
    when 'Переместить поезд по маршруту вперед'
      go_train_to_next_station(params[:train_number])
    when 'Переместить поезд по маршруту назад'
      go_train_to_prev_station(params[:train_number])
    else
      puts "ОТЛАДОЧНЫЙ ВЫВОД: В make_action! нет action '#{action}'"
    end
    p self
  rescue StandardError => e
    update_status(e.message)
  end

  ######### GETTERS #########

  def routes
    @routes.all
  end

  def stations
    @stations.all
  end

  def trains
    @trains.all
  end

  def wagons
    @wagons.all
  end

  ######### TEST DATA #########

  def create_test_data
    %w[1 2].each do |i|
      @wagons.create_cargo_wagon("QQ-#{i * 4}", 50)
      @wagons.create_passenger_wagon("WW-#{i * 4}", 20)
      @trains.create_cargo_train("QQQ-#{i * 3}")
      @trains.create_passenger_train("WWW-#{i * 3}")
      @stations.create_station("St#{i}")
    end

    create_route('RRRR-11', 'St1', 'St2')
    create_route('RRRR-22', 'St2', 'St1')
    set_route_for_train('QQQ-111', 'RRRR-11')
    set_route_for_train('QQQ-222', 'RRRR-22')
    set_route_for_train('WWW-111', 'RRRR-11')
    set_route_for_train('WWW-222', 'RRRR-22')

    attach_wagon_to_train('QQQ-111', 'QQ-1111')
    attach_wagon_to_train('QQQ-222', 'QQ-2222')
    attach_wagon_to_train('WWW-111', 'WW-1111')
    attach_wagon_to_train('WWW-222', 'WW-2222')
  end

  private

  ######### FIND RESOURCE #########

  def find_route(number)
    route = @routes.find(number)
    @errors << "Маршрут с номером '#{number}' не найден" if route.nil?
    route
  end

  def find_station(name)
    station = @stations.find(name)
    @errors << "Станция названием '#{name}'не найдена" if station.nil?
    station
  end

  def find_train(number)
    train = @trains.find(number)
    @errors << "Поезд с номером '#{number}' не найден" if train.nil?
    train
  end

  def find_wagon(number)
    wagon = @wagons.find(number)
    @errors << "Вагон с номером '#{number}' не найден" if wagon.nil?
    wagon
  end

  ######### ROUTE #########

  def create_route(number, start_station_name, end_station_name)
    start_station = find_station(start_station_name)
    end_station = find_station(end_station_name)
    return update_status(@errors) if @errors.any?

    update_status(@routes.create_route(number, start_station, end_station))
  end

  def add_station_to_route(route_number, station_name)
    route = find_route(route_number)
    station = find_station(station_name)
    return update_status(@errors) if @errors.any?

    route.add_station(station)
    update_status('Станция добавлена к маршруту.')
  end

  def delete_station_from_route(route_number, station_name)
    route = find_route(route_number)
    station = find_station(station_name)
    return update_status(@errors) if @errors.any?

    route.delete_station(station)
    update_status('Станция удалена из маршрута')
  end

  ######### TRAIN #########

  def attach_wagon_to_train(train_number, wagon_number)
    train = find_train(train_number)
    wagon = find_wagon(wagon_number)
    return update_status(@errors) if @errors.any?

    train.attach_wagon(wagon)
    update_status('Вагон прицеплен к поезду')
  end

  def dettach_wagon_to_train(train_number, wagon_number)
    train = find_train(train_number)
    wagon = find_wagon(wagon_number)
    return update_status(@errors) if @errors.any?

    train.dettach_wagon(wagon)
    update_status('Вагон отцеплен от поезда')
  end

  def set_route_for_train(train_number, route_number)
    train = find_train(train_number)
    route = find_route(route_number)
    return update_status(@errors) if @errors.any?

    train.set_route(route)
    update_status('Маршрут назначен поезду')
  end

  def go_train_to_next_station(number)
    train = find_train(number)
    return update_status(@errors) if @errors.any?

    train.go_to_next_station
    update_status('Поезд перемещен')
  end

  def go_train_to_prev_station(number)
    train = find_train(number)
    return update_status(@errors) if @errors.any?

    train.go_to_prev_station
    update_status('Поезд перемещен')
  end

  ######### WAGON #########

  def take_seat_in_wagon(wagon_number, place_number)
    wagon = find_wagon(wagon_number)
    @errors << 'Занять место можно только в пассажирском вагоне' if wagon.nil? || !wagon.passenger?
    return update_status(@errors) if @errors.any?

    wagon.take_seat(place_number)
    update_status('Место успешно занято')
  end

  def take_up_volume_in_wagon(wagon_number, volume)
    wagon = find_wagon(wagon_number)
    @errors << 'Загрузить можно только грузовой вагон' if wagon.nil? || !wagon.cargo?
    return update_status(@errors) if @errors.any?

    wagon.take_up_volume(volume)
    update_status('Вагон успешно загружен')
  end

  ######### STATUS #########

  def reset_errors_and_status
    reset_errors
    reset_status
  end

  def reset_errors
    @errors = []
  end

  def reset_status
    @status = nil
  end

  def update_status(new_status)
    @status = [*new_status].join(",\n")
  end
end
