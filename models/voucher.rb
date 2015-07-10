class Voucher
  ATTRIBUTES = [:id, :customer_id, :company_id, :amount, :currency, :number, :status, :created_at, :updated_at]
  VALIDATED = ATTRIBUTES

  attr_accessor *ATTRIBUTES
  attr_accessor :errors


  def initialize(attr = {})
    attr.merge! defaults # specifically override with defaults
    attr.each { |k, v| send("#{k}=", v) }
    @errors = {}
  end

  def save
    validate!
  end

  def to_json(options = {})
    attributes.inject({}) do |hash, (attr, value)|
      hash[attr] = value
      hash
    end.to_json
  end

  private
  def defaults
    {
      :id         => DB.for_voucher,
      :number     => generate_number,
      :status     => "generated",
      :created_at => Time.now,
      :updated_at => Time.now
    }
  end

  def validate!
    validated.each do |attr, value|
      if value.nil?
        errors[attr] = "must be present"
        return false
      end
    end
    errors.empty?
  end

  def generate_number
    self.number ||= ('a'..'z').to_a.shuffle[0,8].join.upcase
  end

  def attributes
    ATTRIBUTES.inject({}) { |hash, attr| hash[attr] = self.send(attr); hash }
  end

  def validated
    VALIDATED.inject({}) { |hash, attr| hash[attr] = self.send(attr); hash }
  end

end
