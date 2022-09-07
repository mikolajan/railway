require_relative 'base'
require_relative '../validator/train'
require_relative '../train/cargo'
require_relative '../train/passenger'

module Collection
  class Train < Base
    def create_cargo_train(number)
      create_train(::Train::Cargo, number)
    end

    def create_passenger_train(number)
      create_train(::Train::Passenger, number)
    end

    def find(number)
      find_by_number(number)
    end

    private

    def create_train(resource, number)
      return 'Поезд с таким номером уже существует' if find(number)
      create_resource(resource, 'Поезд успешно создан', number)
    end

    def validator_class
      Validator::Train
    end
  end
end
