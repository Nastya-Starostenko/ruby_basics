require_relative 'instance_counter.rb'

class Route
  include InstanceCounter

  attr_reader :stations, :number

  def initialize(first_station, last_station, stations = [])
    @stations = [first_station, last_station]
    @number = rand(36**3)
    stations&.each { |station| add_station(station) }
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def validate!
    raise "Route must have start station" if first_station.nil?
    raise "Route must have finish station" if last_station.nil?
  end

  def add_station(station)
    self.stations.insert(-2, station)
  end

  def remove_station(station)
    return if station == stations.first || station == stations.last

    stations.delete(station)
  end

  def info
    "Number: #{number}, route: #{stations.map(&:name).join(',')}"
  end
end
