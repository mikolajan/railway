require_relative 'base'
require_relative '../route'

module Collection
  class Route < Base
    def create_route(*params)
      create_resource(::Route, 'Маршрут успешно создан', *params)
    end

    def find(number)
      find_by_number(number)
    end
  end
end
