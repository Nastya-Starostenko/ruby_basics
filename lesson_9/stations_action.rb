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

module RoutesAction
  include Validation

  protected

  def stations_actions(input)
    case input
    when 1 then create_station
    when 2 then stations_info
    when 3 then show_trains_on_the_station
    when 4 then show_all_trains_on_stations
    else puts 'Wrong value'
    end
  end

  def create_station
    puts 'Put station name'
    name = gets.to_s
    Station.new(name)
    puts "Station added: #{stations.last.name}"
  end

  def add_stantion_to_route(route)
    puts_stations_for_choice(stations)

    route.add_station(selected_station)
  end

  def remove_stantion_from_route(route)
    puts_stations_for_choice(route.stations)

    route.remove_station(selected_station)
  end

  def puts_stations_for_choice(stations)
    stations.each_with_index { |station, index| puts "#{index + 1} - station #{station.name}" }
  end

  def stations_info
    return unless valid_data?(stations)

    stations.each { |station| puts station.info }
  end

  def show_trains_on_the_station
    return unless valid_data?(stations)

    puts 'Select station for info'
    puts_stations_for_choice(stations)
    st = selected_station
    show_all_trains_on_stations([st])
  end

  def show_all_trains_on_stations(need_stations = [])
    stations_for_info = need_stations.empty? ? stations : need_stations
    block = ->(x) { puts "Train number: #{x.number}, type: #{x.type}, wagons count: #{x.wagons.count}" }
    stations_for_info.each { |station| station.action_with_train(&block) }

    back_to_menu
  end

  def selected_station
    puts 'Select number of station'
    index = gets.to_i - 1
    stations[index]
  end

  def set_stations
    %w[Odessa Kharkiv Kiev Moscow Lviv].each do |city|
      Station.new(city)
    end
  end
end
