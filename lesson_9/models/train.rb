# frozen_string_literal: true

require_relative '../modules/manufacturer'
require_relative '../modules/instance_counter'
require_relative '../modules/validation'
require_relative '../modules/acсessors'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  extend Accessors

  NUMBER_FORMAT = /(\w|\d){3}-?(\w|\d){2}/.freeze

  attr_reader :number, :route, :speed, :wagons, :type

  attr_accessor_with_history :current_station

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :type, :presence

  @@trains = []

  def self.find(train_number)
    @@trains.find { |train| train.number == train_number }
  end

  def self.all
    @@trains
  end

  def initialize(type, options = {})
    @type = type
    @number = options[:number] || rand_number
    @speed = 0
    @wagons = options[:wagons]
    @route = options[:route]
    validate!
    add_route
    @@trains << self
    register_instance
  end

  def rand_number
    "#{rand(36**3).to_s(36)}-#{rand(10..99)}"
  end

  def add_wagons(wagons)
    return unless speed.zero?

    self.wagons << wagons
  end

  def remove_wagons(wagons_count)
    return if speed != 0

    wagons.shift(wagons_count)
  end

  def info
    "Train: #{number}, count of wagons: #{wagons.count}, current_station: #{current_station}, speed: #{speed}"
  end

  def move_to_next_station
    return 'There is terminal station' if next_station.nil?

    current_station.train_departure(self)
    update_current_station(next_station)
  end

  def move_to_previous_station
    return 'There is the first station' if index_of_current_station.zero?

    current_station.train_departure(self)
    update_current_station(previous_station)
  end

  def add_route
    return if route.nil?

    update_current_station(route.stations.first)
  end

  def update_current_station(station)
    self.current_station = station
    current_station.add_train(self)
    current_station
  end

  def pick_up_speed
    self.speed += 20
  end

  def slow_down
    self.speed = 0
  end

  def action_with_wagons(&block)
    wagons.each { |wagon| block.call(wagon) }
  end

  private

  attr_writer :number, :route, :speed, :next_station, :previous_station, :current_station, :type

  def index_of_current_station
    route.stations.index(current_station)
  end

  def next_station
    route.stations[index_of_current_station + 1]
  end

  def previous_station
    route.stations[index_of_current_station - 1]
  end
end
