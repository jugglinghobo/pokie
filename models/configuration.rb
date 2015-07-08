class Configuration < ActiveRecord::Base

  serialize :payload, Hash

  def self.find_or_initialize(id)
    find_by_id(id) || new
  end

  def form_attributes
    attrs = attributes
    attrs["payload"] = payload.to_json
    attrs
  end

end
