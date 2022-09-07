module Collection
  class Base
    def initialize
      @instances = []
      init_validator
    end

    def instances_count
      @instances.size
    end

    def all
      @instances
    end

    private

    def find_by_name(name)
      @instances.find { |item| item.name == name}
    end

    def find_by_number(number)
      @instances.find { |item| item.number == number}
    end

    def init_validator; end

    def register_instance(instance)
      @instances << instance
    end

    def create_resource(resource_class_name, success_message, *params)
      resource = resource_class_name.new(*params)
      validator = validator_class.new(resource)
      return validator.errors unless validator.valid?
      register_instance(resource)
      success_message
    end
  end
end
