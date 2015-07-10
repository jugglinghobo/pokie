class Configuration
  class << self
    attr_accessor :configurations
  end

  ROOT = Sinatra::Application.settings.root
  FILENAME = File.expand_path("configurations.yml", "#{ROOT}/db")
  self.configurations = YAML.load_file(FILENAME)

  ATTRIBUTES = [:id, :name, :host, :endpoint, :method, :payload, :auth_enabled, :auth_user, :auth_pass, :created_at, :updated_at]
  VALIDATED = [:name, :host, :endpoint, :method, :payload, :auth_user, :auth_pass]
  attr_accessor *ATTRIBUTES
  attr_accessor :errors

  class << self
    def all
      configurations || []
    end

    def find(id)
      configurations.find { |c| c.id.to_s == id.to_s }
    end

    def find_or_initialize(id)
      find(id) || new
    end

    def save_all
      File.open(FILENAME, 'w') { |f| f.write(Configuration.all.to_yaml) }
    end
  end

  def initialize(attr = {})
    @errors = {}
    attr = defaults.merge attr
    attr.each { |k, v| self.send("#{k}=", v) }
  end

  def update_attributes(attr = {})
    attr.each { |k, v| self.send("#{k}=", v) }
    save
  end

  def save
    if self.id.nil?
      self.id = DB.for_configuration
      configurations << self
    end
    Configuration.save_all
    self
  end

  def destroy
    configurations.delete self
    Configuration.save_all
  end

  def to_s
    name
  end

  def form_attributes
    attrs = attributes.dup
    attrs[:payload] = payload.to_json
    attrs
  end

  private
  def defaults
    {
      :host         => "http://localhost:3000",
      :endpoint     => "/api/",
      :method       => "GET",
      :payload      => {},
    }
  end

  def validate!
    validated_attributes.each do |attr, value|
      if value.nil?
        errors[attr] = "must be present"
      end
    end
    errors.empty?
  end

  def configurations
    self.class.configurations
  end

  def attributes
    ATTRIBUTES.inject({}) { |hash, attr| hash[attr] = self.send(attr); hash }
  end

  def validated_attributes
    VALIDATED.inject({}) { |hash, attr| hash[attr] = self.send(attr); hash }
  end
end
