class Form
  attr_accessor :configuration, :configuration_name, :host, :endpoint, :method, :payload, :response

  def initialize(hash = {})
    hash.each { |k, v| send("#{k}=", v) }
  end

  def payload=(payload)
    @payload = JSON.parse(payload)
  end

  def payload
    @payload || {}
  end

  def configuration_id=(id)
    @configuration = Configuration.find_or_initialize id
  end

  def save
    configuration.update_attributes(
      :name => configuration_name,
      :host => host,
      :endpoint => endpoint,
      :method => method,
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
    @response = JSON.parse response.body
  end

  def get?
    method == "GET"
  end

  def post?
    method == "POST"
  end
end

