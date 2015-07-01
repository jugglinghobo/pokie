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
  puts @form.payload.inspect
  @form.submit_request
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
    puts "inspecing payload:"
    puts payload.inspect
    @payload = YAML.load payload
    puts "PAYLOAD:\n#{@payload}"
  end

  def submit_request
    case method
    when "GET"
      @response = GetRequest.new(self).submit
      return
    when "POST"
      @response = PostRequest.new(self).submit
      return
    else
      raise "Method nNot Supported"
    end
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
  attr_accessor :identifier

  def initialize(identifier)
    @identifier = identifier
  end
end

class Hash
  def pretty
    JSON.pretty_generate self
  end
end
