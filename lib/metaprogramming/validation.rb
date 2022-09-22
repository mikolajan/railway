module Validation
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      include InstanceMethods
    end
  end

  module ClassMethods
    VALIDATIONS_TYPES = %i(between format not_equal presence type )

    def validate(attr, type, options = nil)
      raise 'Undefined validation type' unless VALIDATIONS_TYPES.include?(type)
      validation = { type: type, attr: attr, options: options }
      instance_variable_set(:'@validations', (instance_variable_get(:'@validations') || []) << validation)
    end
  end

  module InstanceMethods
    def valid?
      validate!
      @errors.empty?
    end

    private

    def validate!
      reset_errors

      validations.each do |validation|
        attr_val = instance_variable_get(:"@#{validation[:attr]}")
        error =
          case validation[:type]
          when :between   then between?(attr_val, validation[:options])
          when :format    then format?(attr_val, validation[:options])
          when :not_equal then not_equal?(attr_val, validation[:options])
          when :presence  then presence?(attr_val)
          when :type      then type?(attr_val, validation[:options])
          end

        @errors << "Attribute '#{validation[:attr]}' #{error}." if error
      end
    end

    def validations
      validations = []
      klass = self.class
      until klass == ::Object
        validations.push(*klass.instance_variable_get(:'@validations'))
        klass = klass.superclass
      end
      validations
    end

    def between?(value, range)
      "should between #{range}" unless range.include?(value)
    end

    def format?(value, format)
      "does not match format" if value !~ format
    end

    def presence?(value)
      "should not be nil" if value.nil?
    end

    def type?(value, type)
      "should be '#{type}'" unless value.is_a?(type)
    end

    def not_equal?(value, value2)
      "should not be equal '#{value2}'" if value == value2 || value == instance_variable_get(:"@#{value2}")
    end

    def reset_errors
      @errors = []
    end
  end
end
