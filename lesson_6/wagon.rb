require_relative 'manufacturer.rb'

class Wagon
  include Manufacturer

  attr_reader :type

  def initialize(type)
    @type = type
    validate!
  end

  def valid?
    validate!
    true
  rescue
    false
  end
  
  private
  attr_accessor :train, :number, :info

  def validate!
    raise "Type can't be blank" if type.nil?
  end
end
