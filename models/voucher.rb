class Voucher < ActiveRecord::Base
  before_create :set_number, :set_status

  def set_number
    self.number = ('a'..'z').to_a.shuffle[0,8].join.upcase
  end

  def set_status
    self.status = "generated"
  end
end
