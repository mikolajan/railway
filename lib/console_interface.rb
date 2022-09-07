class ConsoleInterface
  def initialize(railway)
    @railway = railway
  end

  def process(user_input)
    action = get_subtitle(user_input.to_i - 1) if user_input[0].match?(/\d/)
    params = {}

    console_clear

    case action
    when 'Посмотреть список вагонов'
      show_wagons_list
    when 'Создать грузовой вагон', 'Создать пассажирский вагон'
      params[:wagon_number] = get_wagon_name
    when 'Посмотреть список станций'
      show_stations_list
    when 'Создать станцию'
      params[:station_name] = get_station_name
    when 'Просмотреть информацию о станции'
      show_station_info
    when 'Создать маршрут'
      params[:route_number] = get_route_number
      params[:start_station] = get_user_input("Введите начальную станцию маршрута: ")
      params[:end_station] = get_user_input("Введите конечную станцию маршрута: ")
    when 'Посмотреть список всех маршрутов'
      show_routes_list
    when 'Просмотреть информацию о маршруте'
      show_route_info
    when 'Добавить станцию маршруту', 'Удалить станцию из маршрута'
      params[:route_number] = get_route_number
      params[:station_name] = get_station_name
    when 'Создать грузовой поезд', 'Создать пассажирский поезд'
      params[:train_number] = get_train_number
    when 'Посмотреть список поездов'
      show_trains_list
    when 'Посмотреть информацию о поезде'
      show_train_info
    when 'Прицепить вагон к поезду', 'Отцепить вагон от поезда'
      params[:train_number] = get_train_number
      params[:wagon_number] = get_wagon_name
    when 'Назначить маршрут поезду'
      params[:train_number] = get_train_number
      params[:route_number] = get_route_number
    when 'Переместить поезд по маршруту вперед', 'Переместить поезд по маршруту назад'
      params[:train_number] = get_train_number
    else
      show_info("Действие не найдено. Необходимо ввести число от 0 до #{subtitles.size}")
    end

    [action, params]
  end

  def show_railway_status
    show_info(@railway.status)
  end

  def show_actions
    puts
    puts actions
  end

  def get_input
    get_user_input
  end

  private

  ######### GET INFO #########

  def get_user_input(text = "\nВведите номер действия или 0 для выхода из программы: ")
    print text
    input = gets.chomp
    input.empty? ? get_user_input(text) : input
  end

  def get_route_number
    get_user_input("Введите номер маршрута: ")
  end

  def get_train_number
    get_user_input("Введите номер поезда: ")
  end

  def get_wagon_name
    get_user_input("Введите номер вагона: ")
  end

  def get_station_name
    get_user_input("Введите название станции: ")
  end

  ######### SHOW INFO #########

  def show_info(text)
    return if text.to_s.empty?
    puts
    puts '--------'
    puts text
    puts '--------'
  end

  def list_to_show(list)
    list.map { |i| "'#{i}'" }.join(', ')
  end

  def show_route_info
    number = get_route_number
    route = @railway.find_route_by_number(number)
    text = route || "Маршрут с номером '#{number}' не найден."
    show_info(text)
  end

  def show_routes_list
    routes_numbers = @railway.routes_numbers
    text = routes_numbers.any? ? "Список всех маршрутов: #{list_to_show(routes_numbers)}." : 'Маршрутов пока нет.'
    show_info(text)
  end

  def show_station_info
    name = get_station_name
    station = @railway.find_station_by_name(name)
    text = station || "Станция с названием '#{name}' не найдена."
    show_info(text)
  end

  def show_stations_list
    stations_names = @railway.stations_names
    text = stations_names.any? ? "Список всех станций: #{list_to_show(stations_names)}." : 'Станций пока нет.'
    show_info(text)
  end

  def show_train_info
    number = get_train_number
    train = @railway.find_train_by_number(number)
    text = train || "Поезд с номером '#{number}' не найден."
    show_info(text)
  end

  def show_trains_list
    text = if @railway.trains.any?
      cargo_trains_names = @railway.cargo_trains_names
      passenger_trains_names = @railway.passenger_trains_names

      result = "Всего поездов: #{@railway.trains.size}. Из них "
      result += cargo_trains_names.any? ? "грузовые: #{list_to_show(cargo_trains_names)}, " : "грузовых поездов нет, "
      result += passenger_trains_names.any? ? "пассажирские: #{list_to_show(passenger_trains_names)}." : "пассажирских поездов нет."
    else
      'Поездов пока нет.'
    end

    show_info(text)
  end

  def show_wagons_list
    text = if @railway.wagons.any?
      cargo_wagons_names = @railway.cargo_wagons_names
      passenger_wagons_names = @railway.passenger_wagons_names

      result = "Всего вагонов: #{@railway.wagons.size}. Из них "
      result += cargo_wagons_names.any? ? "грузовые: #{list_to_show(cargo_wagons_names)}, " : "грузовых вагонов нет, "
      result += passenger_wagons_names.any? ? "пассажирские: #{list_to_show(passenger_wagons_names)}." : "пассажирских вагонов нет."
    else
      'Вагонов пока нет.'
    end

    show_info(text)
  end

  ######### MENU #########

  def actions
    return @actions if @actions

    @actions = ''
    index = 1
    Railway::ACTIONS.each do |title, subtitles|
      @actions +=  "==== #{title} ====\n"
      subtitles.each do |subtitle|
        @actions += "  #{index} #{subtitle}.\n"
        index += 1
      end
    end

    @actions
  end

  def get_subtitle(subtitle_index)
    subtitles[subtitle_index]
  end

  def subtitles
    return @subtitles if @subtitles
    @subtitles = Railway::ACTIONS.values.flatten
  end

  ######### SYSTEM COMMANDS #########

  def console_clear
    system "clear" or system "cls"
    sleep 0.25
  end
end
