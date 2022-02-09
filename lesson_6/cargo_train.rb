
class CargoTrain < Train
  def initialize(wagons, number)
    super(:cargo, wagons, number)
  end
end
