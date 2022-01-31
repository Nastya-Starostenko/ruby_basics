class Wagon
  attr_reader :type

  def initialize(type)
    @type = type
  end
  
  private
  attr_accessor :train, :number, :info
end
