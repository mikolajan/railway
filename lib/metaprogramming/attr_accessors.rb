module AttrAccessors
  def attr_accessor_with_history(*attrs)
    attrs.each do |attr|
      define_method("#{attr}_history") { instance_variable_get("@#{attr}_history") || [] }  # history
      define_method(attr) { instance_variable_get("@#{attr}") }                             # getter
      define_method("#{attr}=") do |value|
        instance_variable_set("@#{attr}_history", public_send(:"#{attr}_history") << value) # update history
        instance_variable_set("@#{attr}", value)                                            # setter
      end
    end
  end

  def strong_attr_accessor(attr, attr_class)
    define_method(attr) { instance_variable_get("@#{attr}") }
    define_method("#{attr}=") do |value|
      raise TypeError.new("variable class should be #{attr_class.name}") unless value.is_a?(attr_class)
      instance_variable_set("@#{attr}", value)
    end
  end
end
