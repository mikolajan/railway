require_relative 'base'

module Validator
  class Route < Base
    private

    NUMBER_MATCHER = /\A([A-ЯЁ]{4}|[A-Z]{4})-\d{2,}\z/

    def validate
      reset_errors
      validate_number
      validate_stations
    end

    def validate_number
      number = @object.number

      number_errors = []
      number_errors << 'миниммум 7 символов' if number.length < 7
      number_errors << 'например, АБВГ-12 или VWXY-001' unless number.match?(NUMBER_MATCHER)
      if number_errors.any?
        @errors << "Необходимо ввести четыре буквы и не менее двух цифр через дефис, #{number_errors.join(', ')}"
      end
    end

    def validate_stations
      @errors << 'Сначала создайте начальную станцию' if @object.start_station.nil?
      @errors << 'Сначала создайте конечную станцию' if @object.end_station.nil?

      route = @object.route.compact
      @errors << 'Станции в маршруте не могут повторяться.' if route.size != route.uniq.size
    end
  end
end
