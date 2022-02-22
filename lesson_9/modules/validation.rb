# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_accessor :validation

    def validate(attr_name, type, *options)
      @validation ||= []
      @validation << define_method("validate_#{attr_name}_#{type}") { send("validate_#{type}", attr_name, *options) }
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    def validate!
      errors = []
      errors << self.class.validation&.map { |a| send a }
      errors = errors.flatten.compact
      raise TypeError, errors.unshift(self.class.name).join('.') unless errors.empty?
    end

    def variable(attr_name)
      instance_variable_get("@#{attr_name}")
    end

    def validate_presence(attr_name, *_options)
      "#{attr_name} is empty" if variable(attr_name).nil? || variable(attr_name).empty?
    end

    def validate_format(attr_name, *options)
      "#{attr_name} has incorrect format " if variable(attr_name) !~ options.first
    end

    def validate_type(attr_name, *options)
      class_name = Object.const_get(options.first.to_s.split(/(?=[A-Z])/).map(&:capitalize).join)
      "#{variable(attr_name)} has incorrect type, should be #{class_name}" unless variable(attr_name).is_a?(class_name)
    end

    def valid_data?(object)
      errors = []
      errors << 'Sorry, we don`t have enough data' if object.empty?
      errors.unshift(object.class.name) unless errors.empty?
      raise TypeError, errors.join('.') unless errors.empty?

      !!errors
    end
  end
end
