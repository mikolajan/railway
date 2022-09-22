require_relative 'base'
require_relative '../station'

module Collection
  class Station < Base
    def create_station(name)
      return 'Станция с таким названием уже существует' if find(name)

      create_resource(::Station, 'Станция успешно создана', name)
    end

    def find(name)
      find_by_name(name)
    end
  end
end
