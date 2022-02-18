# frozen_string_literal: true

require_relative '../modules/manufacturer'

class Wagon
  include Manufacturer
  include Validator

  attr_reader :type, :number, :train, :occupied_places

  @@wagons = []

  def self.all
    @@wagons
  end

  def initialize(type, total_places)
    @type = type
    @number = rand(36**6).to_s(36)
    @total_places = total_places
    @occupied_places = 0
    validate!
    @@wagons << self
  end

  def attach_train(train)
    self.train = train
    train.wagons << self
  end

  def take_place(count = 1)
    raise 'Wagon does not have enough places' if free_places < count

    self.occupied_places += count
  end

  def free_places
    @total_places - @occupied_places
  end

  private

  attr_accessor :info, :places_count
  attr_writer :train, :occupied_places

  def validate!
    raise "Type can't be blank" if type.nil?
  end
end
