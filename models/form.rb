class Form
  attr_accessor :id, :name, :host, :endpoint, :method, :auth_enabled, :auth_user, :auth_pass, :payload, :response
  alias_method :auth_enabled?, :auth_enabled

  def initialize(hash = {})
    hash.each { |k, v| send("#{k}=", v) }
  end

  def payload=(payload)
    @payload = JSON.parse(payload)
  end

  def payload
    @payload || {}
  end

  def auth_enabled=(enabled)
    @auth_enabled = true if enabled
  end

  def save
    configuration = Configuration.find_or_initialize id
    configuration.update_attributes(
      :name => name,
      :host => host,
      :endpoint => endpoint,
      :method => method,
      :auth_enabled => auth_enabled,
      :auth_user => auth_user,
      :auth_pass => auth_pass,
      :payload => payload
    )
  end

  def submit_request
    case method
    when "GET"
      response = GetRequest.new(self).submit
    when "POST"
      response = PostRequest.new(self).submit
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
end

