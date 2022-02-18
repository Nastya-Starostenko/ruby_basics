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
require_relative 'modules/validator'

module StationsAction
  include Validator

  protected

  def routes_actions(input)
    case input
    when 1 then create_route
    when 2 then edit_route
    else puts 'Wrong value'
    end
  end

  def create_route
    raise 'Please add more stations' if stations.empty? || stations.count < 2

    puts "Select rout's stations"
    puts_stations_for_choice(stations)

    Route.new(selected_station, selected_station)
    puts "Route added: #{routes.last.info}"

    back_to_menu
  end

  def edit_route
    return unless valid_data?(routes)

    route = selected_route

    puts "1 - Add station\n2 - Remove station"
    input = gets.to_i

    case input
    when 1 then add_stantion_to_route(route)
    when 2 then remove_stantion_from_route(route)
    else 'Something wrong'
    end

    back_to_menu
  end

  def selected_route
    puts 'Select number of route'
    routes.each_with_index { |route, index| puts "#{index + 1} - #{route.info}" }
    index = gets.to_i - 1
    routes[index]
  end

  def set_routes
    3.times do
      Route.new(first_station: stations.sample, last_station: stations.sample)
    end
  end
end
