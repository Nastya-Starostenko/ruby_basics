module Manufacturer

  def set_manufacturer(name)
    self.manufacturer = name
  end

  def manufacturer_name
    self.manufacturer
  end

  private
  attr_accessor :manufacturer

end
