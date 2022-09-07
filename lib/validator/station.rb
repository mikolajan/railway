require_relative 'base'

module Validator
  class Station < Base
    private

    NAME_START_MATCHER = /\A[[:upper:]][[:lower:]]/
    NAME_LETTERS_MATCHER = /\A[-\w]+\z/

    def validate
      reset_errors
      validate_name
    end

    def validate_name
      name = @object.name

      name_errors = []
      name_errors << 'иметь миниммум 3 символа' if name.length < 3
      name_errors << 'содержать буквенные символы, цифры и тире' unless name.match?(NAME_LETTERS_MATCHER)
      name_errors << 'начинаться с заглавной и прописной букв' unless name.match?(NAME_START_MATCHER)
      if name_errors.any?
        @errors << "Название станции должно #{name_errors.join(', ')}"
      end
    end
  end
end
