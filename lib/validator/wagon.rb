require_relative 'base'

module Validator
  class Wagon < Base
    private

    WAGON_NUMBER_MATCHER = /\A([A-ЯЁ]{2}|[A-Z]{2})-\d{3,}\z/

    def validate
      reset_errors
      validate_number
    end

    def validate_number
p 'Validator::Wagon'

      number = @object.number

      number_errors = []
      number_errors << 'миниммум 6 символов' if number.length < 6
      number_errors << 'например, АБ-123 или YZ-0011' unless number.match?(WAGON_NUMBER_MATCHER)
      if number_errors.any?
        @errors << "Необходимо ввести две буквы и не менее трех цифр через дефис, #{number_errors.join(', ')}"
      end
    end
  end
end
