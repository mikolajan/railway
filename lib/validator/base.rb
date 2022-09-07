module Validator
  class Base
    attr_reader :errors

    def initialize(object)
      @object = object
    end

    def valid?
      validate
      @errors.empty?
    end

    private

    def reset_errors
      @errors = []
    end
  end
end
