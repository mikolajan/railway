module Instanceable
 def self.included(base)
    base.class_eval do
      extend ClassMethods
      include InstanceMethods
    end
  end

  module ClassMethods
    def instances
      @instances ||= []
    end

    def instances_count
      @instances.size
    end
  end

  module InstanceMethods
    private

    def register_instance
      self.class.instances << self
    end
  end
end
