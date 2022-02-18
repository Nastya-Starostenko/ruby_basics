# frozen_string_literal: true

require_relative '../modules/manufacturer'
require_relative '../modules/instance_counter'
require_relative '../modules/validator'

class Station
  include InstanceCounter
  include Validator

  attr_accessor :name, :trains

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name, trains = [])
    @name = name
    @trains = trains
    validate!
    @@stations << self
    register_instance
  end

  def action_with_train(&block)
    puts "Station: #{name}"
    trains.each { |train| block.call(train) }
  end

  def add_train(train)
    return if trains.include? train

    trains << train
  end

  def info
    "Station #{name}, count of trains: cargo: #{train_cont_by_type(types_of_train.first)},
 pass: #{train_cont_by_type(types_of_train.last)} "
  end

  def trains_by_type(type)
    trains.select { |train| train.type == type }
  end

  def show_all_trains
    trains
  end

  def train_departure(train)
    return if trains.empty?

    trains.delete(train)
  end

  def train_cont_by_type(type)
    trains_by_type(type).count
  end

  def types_of_train
    trains.map(&:type).uniq
  end

  private

  def validate!
    raise "Name can't be blank" if name.nil?
  end
end
