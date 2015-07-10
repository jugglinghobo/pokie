class Voucher
  attr_accessor :id, :customer_id, :company_id, :amount, :currency, :number, :status, :created_at, :updated_at

  def initialize(attr = {})
    attr.reverse_merge defaults
    attr.each { |k, v| send("##{k}=", v) }
  end

  def save
    validate!
  end

  private
  def defaults
    {
      :id         => next_id,
      :number     => generate_number,
      :status     => "generated",
      :created_at => Time.now,
      :updated_at => Time.now
    }
  end

  def next_id
    ID.for_voucher
  end

  def generate_number
    self.number ||= ('a'..'z').to_a.shuffle[0,8].join.upcase
  end

end
