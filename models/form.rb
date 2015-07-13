class Form
  ATTRIBUTES = [:id, :name, :host, :endpoint, :method, :auth_enabled, :auth_user, :auth_pass, :payload, :response, :created_at, :updated_at, :errors]
  VALIDATES = [:host, :endpoint, :method, :payload]
  attr_accessor *ATTRIBUTES
  alias_method :auth_enabled?, :auth_enabled

  def initialize(hash = {})
    @errors = {}
    hash.each { |k, v| send("#{k}=", v) }
  end

  def payload=(payload)
    begin
      @payload = JSON.parse(payload)
    rescue
      @payload = payload
      errors[:payload] = "invalid JSON format"
    end
  end

  def auth_enabled=(enabled)
    @auth_enabled = true if enabled
  end

  def save
    configuration = Configuration.find_or_initialize id
    configuration = configuration.update_attributes(
      :name => name,
      :host => host,
      :endpoint => endpoint,
      :method => method,
      :auth_enabled => auth_enabled,
      :auth_user => auth_user,
      :auth_pass => auth_pass,
      :payload => payload
    )
    initialize(configuration.form_attributes)
  end

  def submit_request
    case method
    when "GET"
      response = GetRequest.new(self).submit
    when "POST"
      response = PostRequest.new(self).submit
    when "PATCH"
      response = PatchRequest.new(self).submit
    else
      raise "Method Not Supported"
    end
    begin
      @response = JSON.parse response.body
    rescue JSON::ParserError
      @response = {:error => response.body}
    end
  end

  def get?
    method == "GET"
  end

  def post?
    method == "POST"
  end

  def patch?
    method == "PATCH"
  end

  def validate!(options = {})
    validated_attributes.each do |attr, value|
      if value.empty?
        errors[attr] = "must be present"
      end
    end
    if options[:include_name]
      errors[:name] = "must be present" if name.empty?
    end
    errors.empty?
  end

  def valid?(options = {})
    validate!(options)
    errors.empty?
  end

  def validated_attributes
    VALIDATES.inject({}) { |hash, attr| hash[attr] = self.send(attr); hash }
  end
end

