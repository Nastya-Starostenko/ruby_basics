
class CargoTrain < Train
  def initialize(wagons, number, route = nil)
    super(:cargo, wagons, number, route)
  end
end
