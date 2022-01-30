
class CargoTrain < Train

  def initialize(wagons_count)
    wagons = wagons_count.times.map { CargoWagon.new }
    super(:cargo, wagons)
  end
end
