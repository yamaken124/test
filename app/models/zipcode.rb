class Zipcode < ActiveRecord::Base

  def self.set_address_from_zipcode(code)
    address = ZipCodeJp.find(code)
  end

end