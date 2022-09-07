require_relative 'route'
require_relative 'station'
require_relative 'wagon/cargo'
require_relative 'wagon/passenger'
require_relative 'train/cargo'
require_relative 'train/passenger'

class Railway
  ACTIONS = {
    'Поезд' => [
      'Посмотреть список поездов',
      'Посмотреть информацию о поезде',
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
      'Создать грузовой вагон'
    ],
    'Станция' => [
      'Посмотреть список станций',
      'Просмотреть информацию о станции',
      'Создать станцию'
    ],
    'Маршрут' => [
      'Посмотреть список всех маршрутов',
      'Просмотреть информацию о маршруте',
      'Создать маршрут',
      'Добавить станцию маршруту',
      'Удалить станцию из маршрута'
    ]
  }

  # attr_reader :stations, :trains, :routes, :wagons, :status
  attr_reader :status, :trains, :wagons

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end

  def make_action!(action, params)
    reset_status

    case action
     when 'Создать грузовой вагон'
      create_cargo_wagon(params[:wagon_number])
    when 'Создать пассажирский вагон'
      create_passenger_wagon(params[:wagon_number])
    when 'Создать станцию'
      create_station(params[:station_name])
    when 'Создать маршрут'
      create_route(params[:route_number], params[:start_station], params[:end_station])
    when 'Добавить станцию маршруту'
      add_station_to_route(params[:route_number], params[:station_name])
    when 'Удалить станцию из маршрута'
      delete_station_from_route(params[:route_number], params[:station_name])
    when 'Создать грузовой поезд'
      create_cargo_train(params[:train_number])
    when 'Создать пассажирский поезд'
      create_passenger_train(params[:train_number])
    when 'Прицепить вагон к поезду'
      attach_wagon_to_train(params[:train_number], params[:wagon_number])
    when 'Отцепить вагон от поезда'
      dettach_wagon_to_train(params[:train_number], params[:wagon_number])
    when 'Назначить маршрут поезду'
      set_route_for_train(params[:train_number], params[:route_number])
    when 'Переместить поезд по маршруту вперед'
      go_train_to_next_station(params[:train_number])
    when 'Переместить поезд по маршруту назад'
      go_train_to_prev_station(params[:train_number])
    else
      puts "ОТЛАДОЧНЫЙ ВЫВОД: В make_action! нет action '#{action}'"
    end
    p self
  end

  def find_route_by_number(number)
    @routes.find { |route| route.number == number }
  end

  def find_station_by_name(name)
    @stations.find { |station| station.name == name }
  end

  def find_train_by_number(number)
    @trains.find { |train| train.number == number }
  end

  def find_wagon_by_number(number)
    @wagons.find { |wagon| wagon.number == number }
  end

  def routes_numbers
    get_numbers_for(@routes)
  end

  def stations_names
    get_names_for(@stations)
  end

  def cargo_wagons_names
    get_numbers_for(cargo_wagons)
  end

  def passenger_wagons_names
    get_numbers_for(passenger_wagons)
  end

  def cargo_trains_names
    get_numbers_for(cargo_trains)
  end

  def passenger_trains_names
    get_numbers_for(passenger_trains)
  end

  private

  def add_station_to_route(route_number, station_name)
    errors = []

    route = find_route_by_number(route_number)
    errors.push('Маршрут с таким названием не найден.') if route.nil?
    errors.push("Станция с названием #{station_name} не существует.") unless stations_names.include?(station_name)

    if errors.any?
      update_status(errors)
    else
      route.add_station(station_name)
      update_status('Станция добавлена к маршруту.')
    end
  end

  def get_numbers_for(list)
    list.map(&:number)
  end

  def get_names_for(list)
    list.map(&:name)
  end

  def cargo_wagons
    get_wagons_by_type(:cargo)
  end

  def passenger_wagons
    get_wagons_by_type(:passenger)
  end

  def get_wagons_by_type(type)
    @wagons.select { |wagon| wagon.type == type }
  end

  def create_cargo_wagon(number)
    if cargo_wagons_names.include?(number)
      update_status("Грузовой вагон с таким номером уже существует.")
    else
      add_wagon(Wagon::Cargo.new(number))
      update_status("Вагон успешно создан.")
    end
  end

  def create_passenger_wagon(number)
    if passenger_wagons_names.include?(number)
      update_status("Пассажирский вагон с таким номером уже существует.")
    else
      add_wagon(Wagon::Passenger.new(number))
      update_status("Вагон успешно создан.")
    end
  end

  def add_wagon(wagon)
    @wagons.push(wagon)
  end

  def cargo_trains
    get_trains_by_type(:cargo)
  end

  def passenger_trains
    get_trains_by_type(:passenger)
  end

  def get_trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def create_passenger_train(number)
    if passenger_trains_names.include?(number)
      update_status("Пассажирский поезд с таким номером уже существует.")
    else
      add_train(Train::Passenger.new(number))
      update_status("Поезд успешно создан.")
    end
  end

  def create_cargo_train(number)
    if cargo_trains_names.include?(number)
      update_status("Грузовой поезд с таким номером уже существует.")
    else
      add_train(Train::Passenger.new(number))
      update_status("Поезд успешно создан.")
    end
  end

  def add_train(train)
    @trains.push(train)
  end

  def create_station(station_name)
    if stations_names.include?(station_name)
      update_status("Станция с таким названием уже существует.")
    else
      add_station(Station.new(station_name))
      update_status("Станция успешно создана.")
    end
  end

  def add_station(station)
    @stations.push(station)
  end

  def add_route(route)
    @routes.push(route)
  end

  def create_route(number, start_station_name, end_station_name)
    errors = []

    errors.push('Маршрут с таким названием уже существует.') if routes_numbers.include?(number)
    errors.push('Станции в маршруте не могут повторяться.') if start_station_name == end_station_name

    [start_station_name, end_station_name].uniq.each do |station_name|
      errors.push("Станция с названием #{station_name} не существует.") unless stations_names.include?(station_name)
    end

    if errors.any?
      update_status(errors)
    else
      start_station, end_station = [start_station_name, end_station_name].map do |station_name|
        find_station_by_name(station_name)
      end
      add_route(Route.new(number, start_station, end_station))
      update_status('Маршрут успешно создан.')
    end
  end

  def add_station_to_route(route_number, station_name)
    errors = []

    route = find_route_by_number(route_number)
    errors.push('Маршрут с таким номером не найден.') if route.nil?
    if route && route.get_route.include?(station_name)
      errors.push("Станция с названием #{station_name} уже есть в маршруте.")
    else
      errors.push("Станция с названием #{station_name} не существует.") unless stations_names.include?(station_name)
    end

    if errors.any?
      update_status(errors)
    else
      route.add_station(find_station_by_name(station_name))
      update_status('Станция добавлена к маршруту.')
    end
  end

  def attach_wagon_to_train(train_number, wagon_number)
    errors = []

    train = find_train_by_number(train_number)
    errors.push('Поезд с таким номером не найден.') if train.nil?
    wagon = find_wagon_by_number(train_number)
    errors.push('Вагон с таким номером не найден.') if wagon.nil?

    # TO_DO add validation for available attach wagon
    if errors.any?
      update_status(errors)
    else
      result = train.attach_wagon(wagon)
      update_status("Вагон #{'не ' if result.nil?}прицеплен к поезду.")
    end
  end

  def dettach_wagon_to_train(train_number, wagon_number)
    errors = []

    train = find_train_by_number(train_number)
    errors.push('Поезд с таким номером не найден.') if train.nil?
    wagon = find_wagon_by_number(wagon_number)
    errors.push('Вагон с таким номером не найден.') if wagon.nil?

    # TO_DO add validation for available dettach wagon
    if errors.any?
      update_status(errors)
    else
      result = train.dettach_wagon(wagon)
      update_status("Вагон #{'не ' if result.nil?}отцеплен от поезда.")
    end
  end

  def delete_station_from_route(route_number, station_name)
    errors = []

    route = find_route_by_number(route_number)
    errors.push('Маршрут с таким номером не найден.') if route.nil?
    if route && route.get_route.include?(station_name)
      if route.get_route.first == station_name || route.get_route.last == station_name
        errors.push("Нельзя удалить начальную или конечную станцию.")
      end
    else
      errors.push("Станция с названием #{station_name} в маршруте не найдена.") unless stations_names.include?(station_name)
    end

    if errors.any?
      update_status(errors)
    else
      route.delete_station(station_name)
      update_status('Станция удалена из маршрута.')
    end
  end

  def go_train_to_next_station(number)
    errors = []

    train = find_train_by_number(number)
    errors.push('Поезд с таким номером не найден.') if train.nil?

    if errors.any?
      update_status(errors)
    else
      result = train.go_to_next_station
      p "result: #{result.inspect}"

      text = result.nil? ? 'поезд не передвинулся' : 'поезд перемещен'
      update_status(text)
    end
  end

  def go_train_to_prev_station(number)
    errors = []

    train = find_train_by_number(number)
    errors.push('Поезд с таким номером не найден.') if train.nil?

    if errors.any?
      update_status(errors)
    else
      result = train.go_to_prev_station
      p "result: #{result.inspect}"

      text = result.nil? ? 'поезд не передвинулся' : 'поезд перемещен'
      update_status(text)
    end
  end

  def set_route_for_train(train_number, route_number)
    errors = []

    train = find_train_by_number(train_number)
    errors.push('Поезд с таким номером не найден.') if train.nil?
    route = find_route_by_number(route_number)
    errors.push('Маршрут с таким номером не найден.') if route.nil?

    if errors.any?
      update_status(errors)
    else
      train.set_route(route)
      update_status('Маршрут назначен поезду.')
    end
  end

  def reset_status
    @status = nil
  end

  def update_status(new_status)
    @status = [*new_status].join("\n")
  end
end
