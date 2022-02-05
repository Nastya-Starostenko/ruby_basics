require_relative 'manufacturer.rb'

class Wagon
  include Manufacturer

  attr_reader :type

  def initialize(type)
    @type = type
  end

  private
  attr_accessor :train, :number, :info
end
