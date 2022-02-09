require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'


class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :route, :speed, :wagons, :next_station, :previous_station, :current_station, :type

  @@trains = []

  def self.find(train_number)
    @@trains.find { |train| train.number == train_number }
  end

  def initialize(type, wagons, number)
    @number = number
    @type = type
    @speed = 0
    @wagons = []
    validate!
    add_wagons(wagons)
    @@trains << self
    register_instance
  end

  def pick_up_speed
    self.speed += 20
  end

  def slow_down
    self.speed = 0
  end

  def add_wagons(wagons)
    return if speed != 0

    wagons.keep_if { |wagon| wagon.type == type }.each {|wagon| self.wagons << wagon}
  end

  def remove_wagons(wagons_count)
    return if speed != 0

    self.wagons.shift(wagons_count)
  end

  def info
    "Train: #{number}, count of wagons: #{wagons.count}, current_station: #{current_station}, speed: #{speed}"
  end

  def move_to_previous_station
    return 'There is the first station' if previous_station.nil?

    self.next_station = current_station
    self.current_station = previous_station
    index = index_of_current_station - 1
    self.previous_station = index >= 0 ? route.stations[index] : nil

    next_station.train_departure(self)
    current_station.add_train(self)
    current_station
  end

  def move_to_next_station
    return 'There is terminal station' if next_station.nil?

    self.previous_station = current_station
    self.current_station = next_station
    index = index_of_current_station + 1
    self.next_station = index <= route.stations.count ? route.stations[index] : nil

    previous_station.train_departure(self)
    current_station.add_train(self)
    current_station
  end

  def add_route(route)
    self.route = route
    self.current_station = route.stations.first
    self.next_station = route.stations[1]

    current_station.add_train(self)
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  private

  attr_writer :number, :route, :speed, :next_station, :previous_station, :current_station, :type

  def validate!
    raise "Number can't be blank" if number.nil?
    raise "Number has incorrect format, should be '3 any words or digits - 2 any words or digits'"  if number !~ /(\w|\d){3}-?(\w|\d){2}/
    raise "Type can't be blank" if type.nil?
    raise "Train must have atleast 1 wagon" if wagons.blank?
  end

  def index_of_current_station
    route.stations.index(current_station)
  end


end
