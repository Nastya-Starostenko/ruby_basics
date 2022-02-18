# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/validator'

class Route
  include InstanceCounter
  include Validator

  attr_reader :stations, :number

  @@routes = []

  def self.all
    @@routes
  end

  def initialize(first_station:, last_station:, stations: [])
    @stations = [first_station, last_station]
    @number = rand(36**3)
    stations&.each { |station| add_station(station) }
    @@routes << self
  end

  def validate!
    errors = []
    errors << 'Route must have start station' if stations.first.nil?
    errors << 'Route must have finish station' if stations.last.nil?

    raise errors.join('.') unless errors.empty?
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def remove_station(station)
    return if station == stations.first || station == stations.last

    stations.delete(station)
  end

  def info
    "Number: #{number}, route: #{stations.map(&:name).join(',')}"
  end
end
