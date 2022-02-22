# frozen_string_literal: true

require_relative 'models/route'
require_relative 'models/train'
require_relative 'models/passenger_train'
require_relative 'models/cargo_train'
require_relative 'models/station'
require_relative 'models/wagon'
require_relative 'models/cargo_wagon'
require_relative 'models/passenger_wagon'
require_relative 'modules/manufacturer'
require_relative 'modules/instance_counter'
require_relative 'modules/validation'

module TrainsAction
  include Validation

  protected

  def trains_actions(input)
    case input
    when 1 then create_new_train
    when 2 then add_route_for_train
    when 3 then add_wagon_for_train
    when 4 then remove_wagon_from_train
    when 5 then  move_train_forward
    when 6 then  move_train_back
    else puts 'Wrong value'
    end
  end

  def create_new_train
    puts "1 - create cargo train\n2 - create passenger train\n0 - back to previous menu"

    input = gets.to_i
    return if input.zero?

    case input
    when 1 then create_passenger_train
    when 2 then create_cargo_train
    else
      'Error: menu has an invalid value'
    end

    back_to_menu
  end

  def create_cargo_train
    CargoTrain.new(wagons: create_wagons_by_type(:cargo), number: train_number)
  end

  def create_passenger_train
    PassengerTrain.new(wagons: create_wagons_by_type(:passenger), number: train_number)
  end

  def train_number
    puts 'Put train name or put 0 for random value'
    number = gets.chomp
    nil if number == '0'
  end

  def add_route_for_train
    return unless valid_data?(routes) && valid_data?(trains)

    train = selected_train
    train.add_route(selected_route)
    puts train.info.to_s

    back_to_menu
  end

  def selected_train
    puts 'Select train'
    trains.each_with_index do |train, index|
      puts "#{index + 1} - train #{train.number}, #{train.type}, route: #{train.route.info}"
    end
    index = gets.to_i - 1
    trains[index]
  end

  def add_wagon_for_train
    return unless valid_data?(trains)

    train = selected_train
    wagons = create_wagons_by_type(train.type)
    train.add_wagons(wagons)
    puts train.info.to_s

    back_to_menu
  end

  def remove_wagon_from_train
    return unless valid_data?(trains)

    puts 'How many wagos need remove?'
    count = gets.to_i
    train = selected_train
    train.remove_wagons(count)
    puts train.info.to_s

    back_to_menu
  end

  def move_train_forward
    return unless valid_data?(trains)

    train = selected_train
    train.move_to_next_station
    puts train.info.to_s

    back_to_menu
  end

  def move_train_back
    return unless valid_data?(trains)

    train = selected_train
    train.move_to_previous_station
    puts train.info.to_s

    back_to_menu
  end

  def show_all_wagons_on_trains(need_trains = [])
    trains_for_info = need_trains.empty? ? trains : need_trains
    block = lambda do |x|
      info = "free places: #{x.free_places}, occupied places #{x.occupied_places}"
      puts "Wagon number: #{x.number}, type: #{x.type},  #{info}"
    end
    trains_for_info.each do |train|
      puts "Train: #{train.number}"
      train.action_with_wagons(&block)
    end

    back_to_menu
  end
end
