# frozen_string_literal: true

class CargoTrain < Train
  def initialize(**args)
    super(:cargo, **args)
  end
end
