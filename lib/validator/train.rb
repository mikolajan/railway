require_relative 'base'

module Validator
  class Train < Base
    private

    TRAIN_NUMBER_MATCHER = /\A([A-ЯЁ]{3}|[A-Z]{3})-\d{3,}\z/

    def validate
      reset_errors
      validate_number
    end

    def validate_number
p 'Validator::Train'
      number = @object.number

      number_errors = []
      number_errors << 'миниммум 7 символов' if number.length < 7
      number_errors << 'например, АБВ-123 или XYZ-0011' unless number.match?(TRAIN_NUMBER_MATCHER)
      if number_errors.any?
        @errors << "Необходимо ввести три буквы и не менее трех цифр через дефис, #{number_errors.join(', ')}."
      end
    end
  end
end
