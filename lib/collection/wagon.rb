require_relative 'base'
require_relative '../wagon/cargo'
require_relative '../wagon/passenger'

module Collection
  class Wagon < Base
    def create_cargo_wagon(*params)
      create_wagon(::Wagon::Cargo, *params)
    end

    def create_passenger_wagon(*params)
      create_wagon(::Wagon::Passenger, *params)
    end

    def find(number)
      find_by_number(number)
    end

    private

    def create_wagon(resource, number, num)
      return 'Вагон с таким номером уже существует' if find(number)

      create_resource(resource, 'Вагон успешно создан', number, num)
    end
  end
end
