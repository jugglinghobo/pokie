class Configuration < ActiveRecord::Base

  serialize :payload, Hash

  def self.find_or_initialize(id)
    find_by_id(id) || new
  end

  def to_s
    name || ""
  end

  def form_attributes
    attrs = {
      :configuration => self,
      :host => host,
      :endpoint => endpoint,
      :payload => payload.to_json,
      :method => method
    }
    attrs
  end

end
