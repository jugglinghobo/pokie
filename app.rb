require 'rubygems'
require 'sinatra'
require 'net/http'
require 'uri'
require 'json'
require 'yaml'

get '/' do
  @form = Form.new
  erb :index
end

post '/' do
  @form = Form.new params
  @form.submit_request
  erb :index
end

post '/load_configuration' do
  @configuration = Configuration.find params[:name]
  @form = Form.new configuration.form_attributes
  erb :index
end

class Form

  attr_accessor :host, :endpoint, :payload, :method, :response

  def initialize(hash = {})
    hash.each { |k, v| send("#{k}=", v) }
  end

  def host
    @host ||= "https://localhost:3000"
  end

  def endpoint
    @endpoint ||= "/api/v1/"
  end

  def payload
    @payload ||= {}
  end

  def payload=(payload)
    @payload = YAML.load payload
  end

  def submit_request
    case method
    when "GET"
      response = GetRequest.new(self).submit
    when "POST"
      response = PostRequest.new(self).submit
    else
      raise "Method nNot Supported"
    end
    @response = JSON.parse response.body
  end


  def get?
    method == 'GET'
  end

  def post?
    method == 'POST'
  end

end

class APIRequest
  attr_accessor :form
  def initialize(form)
    @form = form
  end

  def uri
    URI.parse "#{form.host}#{form.endpoint}"
  end

  def http
    Net::HTTP.new uri.host, uri.port
  end

  def submit
    http.request request
  end
end

class GetRequest < APIRequest
  def request
    uri.query = URI.encode_www_form form.payload
    Net::HTTP::Get.new(uri.request_uri)
  end
end

class PostRequest < APIRequest
  def request
    req = Net::HTTP::Post.new(uri.request_uri)
    req.body = form.payload.to_json
    req['Content-Type'] = 'application/json'
    req
  end
end

class Configuration
  attr_accessor :name, :host, :endpoint, :payload, :method

  DEFAULTS = {
    :host => "http://localhost:3000",
    :endpoint => "/api/v1/ping",
    :payload => "",
    :method => "GET"
  }

  def self.all
    CONFIGURATIONS
  end

  def self.find(name)
    CONFIGURATIONS.find { |c| c.name == name }
  end

  def initialize(hash = {})
    hash = DEFAULTS.merge hash
    # initialize with default value if none passed
    hash.each { |k, v| send("#{k}=", v) }
  end

  def form_attributes
    attrs = {
      :host => host,
      :endpoint => endpoint,
      :payload => payload,
      :method => method
    }
    attrs
  end
end

class Hash
  def pretty
    JSON.pretty_generate self
  end
end

CONFIGURATIONS = [
  Configuration.new(
    :name => "ping",
    :endpoint => "/api/v1/ping",
    :method => "GET"
  ),
  Configuration.new(
    :name => "POST transaction",
    :endpoint => "/api/v1/transactions",
    :method => "POST",
    :payload => '{
      "customer_id": "1",
      "point_of_sale_id": "1",
      "sales_person": "Mr. ABC",
      "number": "abc2",
      "total_price": "25.25",
      "relevant_price": "2.25",
      "currency": "USD",
      "transaction_type": "Type",
      "transaction_date": "06.05.2015",
      "company_id": "1",
      "transaction_items": [
        {
          "article_id": "1",
          "article_description": "Article",
          "price": "25.25",
          "discounted": "True"
        },
        {
          "article_id": "2",
          "article_description": "Article",
          "price": "25.25",
          "discounted": "True"
        }
      ]
    }',
  )
]
