# frozen_string_literal: true

require_relative 'manufacturer'

class Wagon
  include Manufacturer

  attr_reader :type, :number, :train, :free_places, :occupied_places

  def initialize(type, places_count)
    @type = type
    @number = rand(36**6).to_s(36)
    @places_count = places_count
    @free_places = places_count
    @occupied_places = 0
    validate!
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def attach_train(train)
    self.train = train
  end

  def take_place(count = 1)
    raise 'Wagon doesn`t have enough places' if free_places < count

    self.occupied_places += count
    self.free_places -= count
  end

  private

  attr_accessor :info, :places_count
  attr_writer :train, :free_places, :occupied_places

  def validate!
    raise "Type can't be blank" if type.nil?
  end
end
