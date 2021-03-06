require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'

class Station
  include InstanceCounter

  attr_accessor :name, :trains

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def add_train(train)
    return if trains.include? train

    trains << train
  end

  def info
    "Station #{name}, count of trains: cargo: #{train_cont_by_type(types_of_train.first)}, pass: #{train_cont_by_type(types_of_train.last)} "
  end

  def trains_by_type(type)
    trains.select { |train| train.type == type} 
  end

  def show_all_trains
    trains
  end

  def train_departure(train)
    return if trains.empty?

    trains.delete(train)
  end

  def train_cont_by_type(type)
    trains.select {|train| train.type == type }.count
  end

  def types_of_train
    trains.map {|train| train.type}.uniq
  end

  private

  def validate!
    raise "Name can't be blank" if name.nil?
  end
end
