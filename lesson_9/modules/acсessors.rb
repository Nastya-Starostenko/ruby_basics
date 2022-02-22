# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*methods)
    methods.each do |method|
      define_method("#{method}_history") { instance_variable_get("@#{method}_history") }
      define_method(method) { instance_variable_get("@#{method}") }
      define_method("#{method}=") do |v|
        instance_variable_set("@#{method}_history", []) if instance_variable_get("@#{method}_history").nil?
        instance_variable_set("@#{method}_history", []) if instance_variable_get("@#{method}_history").nil?

        instance_variable_set("@#{method}_history", instance_variable_get("@#{method}_history") << v)
        instance_variable_set("@#{method}", v)
      end
    end
  end

  def strong_attr_accessor(name, type)
    define_method(name) { instance_variable_get("@#{name}") }
    define_method("#{name}=") do |value|
      class_name = Object.const_get(type.to_s.split(/(?=[A-Z])/).map(&:capitalize).join)
      raise DataError, 'Variable has wrong class' unless value.is_a?(class_name)

      instance_variable_set("@#{name}", value)
    end
  end
end
