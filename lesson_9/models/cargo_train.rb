# frozen_string_literal: true

class CargoTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :type, :presence

  def initialize(**args)
    super(:cargo, **args)
  end
end
