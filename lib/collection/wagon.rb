require_relative 'base'
require_relative '../validator/wagon'
require_relative '../wagon/cargo'
require_relative '../wagon/passenger'

module Collection
  class Wagon < Base
    def create_cargo_wagon(number)
      create_wagon(::Wagon::Cargo, number)
    end

    def create_passenger_wagon(number)
      create_wagon(::Wagon::Passenger, number)
    end

    def find(number)
      find_by_number(number)
    end

    private

    def create_wagon(resource, number)
      return 'Вагон с таким номером уже существует' if find(number)
      create_resource(resource, 'Вагон успешно создан', number)
    end

    def validator_class
      Validator::Wagon
    end
  end
end
