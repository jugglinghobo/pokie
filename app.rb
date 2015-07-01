require 'rubygems'
require 'sinatra'
require 'net/http'
require 'uri'
require 'ostruct'
require 'pp'

get '/' do
  @api_request = APIRequest.new
  erb :index
end

post '/' do
  @api_request = APIRequest.new params
  if @api_request.get?
    @api_request.query = URI.encode_www_form(@api_request.payload_hash)
    response = Net::HTTP.get_response @api_request.uri
    puts response.body
    @api_request.response = response
  end
  erb :index
end

class APIRequest

  attr_accessor :host, :endpoint, :method, :payload_string, :payload_hash, :response

  def initialize(hash = {})
    hash.each { |k, v| send("#{k}=", v) }
  end

  def uri
    @uri ||= URI.parse "#{host}#{endpoint}"
  end

  def payload_string=(payload_string)
    @payload_hash = convert_to_hash payload_string
    @payload_string = payload_string
  end

  def query=(query)
    uri.query = query
  end

  def get?
    method == 'GET'
  end

  def post?
    method == 'POST'
  end

  def convert_to_hash(payload_string)
    hash = {}
    payload_string.split('\n').each do |param|
      key, value = param.split(': ')
      hash[key.strip] = value.strip
    end
    hash
  end

end
