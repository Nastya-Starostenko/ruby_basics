# frozen_string_literal: true

module Validator
  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def validate!; end

  def valid_data?(object)
    errors = []
    errors << 'Sorry, we don`t have enough data' if object.empty?
    errors.unshift(object.class.name) unless errors.empty?
    raise errors.join('.') unless errors.empty?

    !!errors
  end
end
