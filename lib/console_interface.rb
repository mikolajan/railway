class ConsoleInterface
  def initialize(railway)
    @railway = railway
    console_clear
  end

  def process(user_input)
    action = get_subtitle(user_input.to_i - 1) if user_input[0].match?(/\d/)
    params = {}

    console_clear

    case action
    when 'Добавить станцию маршруту', 'Удалить станцию из маршрута'
      params[:route_number] = get_route_number
      params[:station_name] = get_station_name
    when 'Назначить маршрут поезду'
      params[:train_number] = get_train_number
      params[:route_number] = get_route_number
    when 'Посмотреть список вагонов'
      show_wagons_list
    when 'Посмотреть список маршрутов'
      show_routes_list
    when 'Посмотреть список поездов'
      show_trains_list
    when 'Посмотреть список станций'
      show_stations_list
    when 'Создать грузовой вагон', 'Создать пассажирский вагон'
      params[:wagon_number] = get_wagon_number
    when 'Создать станцию'
      params[:station_name] = get_station_name
    when 'Создать маршрут'
      params[:route_number] = get_route_number
      params[:start_station] = get_user_input("Введите начальную станцию маршрута: ").capitalize
      params[:end_station] = get_user_input("Введите конечную станцию маршрута: ").capitalize
    when 'Создать грузовой поезд', 'Создать пассажирский поезд'
      params[:train_number] = get_train_number
    when 'Прицепить вагон к поезду', 'Отцепить вагон от поезда'
      params[:train_number] = get_train_number
      params[:wagon_number] = get_wagon_number
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
    puts actions
  end

  def get_input
    get_user_input("\nВведите номер действия или 0 для выхода из программы: ")
  end

  private

  ######### GET INFO #########

  def get_user_input(text)
    print text
    input = gets.chomp
    input.empty? ? get_user_input(text) : input
  end

  def get_route_number
    get_user_input("Введите номер маршрута: ").upcase
  end

  def get_train_number
    get_user_input("Введите номер поезда: ").upcase
  end

  def get_wagon_number
    get_user_input("Введите номер вагона: ").upcase
  end

  def get_station_name
    get_user_input("Введите название станции: ").capitalize
  end

  ######### SHOW INFO #########

  def show_info(text)
    return if text.to_s.empty?
    puts "\n-----------\n#{text}.\n-----------\n "
  end

  def show_routes_list
    routes = @railway.routes
    text = routes.any? ? routes.map(&:to_s).sort.join(",\n===\n") : 'Маршрутов пока нет'
    show_info(text)
  end

  def show_stations_list
    stations = @railway.stations
    text = stations.any? ? stations.map(&:to_s).sort.join("\n===\n") : 'Станций пока нет'
    show_info(text)
  end

  def show_trains_list
    trains = @railway.trains
    text = trains.any? ? trains.map(&:to_s).sort.join(",\n===\n") : 'Поездов пока нет'
    show_info(text)
  end

  def show_wagons_list
    wagons = @railway.wagons
    text = wagons.any? ? wagons.map(&:to_s).sort.join(",\n") : 'Вагонов пока нет'
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

  ######### SYSTEM #########

  def console_clear
    system "clear" or system "cls"
    sleep 0.25
  end
end
