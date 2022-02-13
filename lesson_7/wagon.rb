require_relative 'manufacturer.rb'

class Wagon
  include Manufacturer

  attr_reader :type, :number, :train

  def initialize(type)
    @type = type
    @number = rand(36**6).to_s(36)
    validate!
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def attach_train(train)
    self.train = train
  end

  private
  attr_accessor :info
  attr_writer :train

  def validate!
    raise "Type can't be blank" if type.nil?
  end
end
