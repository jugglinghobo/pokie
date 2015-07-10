require 'rubygems'
require 'sinatra'
require 'sinatra/json'
require 'net/http'
require 'uri'
require 'json'
require 'pry'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "dev.sqlite3"}
set :auth_user, "test-api"
set :auth_password, "test-api"

require './db/db'
require './models/form'
require './models/configuration'
require './models/request'
require './models/patches'
require './models/voucher'


get '/' do
  load_configurations
  @form = Form.new @configuration.form_attributes
  erb :index
end

get '/request' do
  redirect '/'
end
post '/request' do
  load_configurations
  @form = Form.new params
  @form.submit_request
  erb :index
end

get '/save_configuration' do
  redirect '/'
end
post '/save_configuration' do
  load_configurations
  @form = Form.new params
  @form.save
  redirect "/?configuration_id=#{@form.id}"
end

post '/vouchers' do
  authorize!
  params = JSON.parse(request.body.read)
  @voucher = Voucher.new params
  if @voucher.save
    json @voucher
  else
    status 422
    json @voucher.errors
  end
end

helpers do
  def authorize!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and
      @auth.basic? and
      @auth.credentials and
      @auth.credentials == [settings.auth_user, settings.auth_password]
  end

  def load_configurations
    @configurations = Configuration.all
    @configuration = Configuration.find_or_initialize params["configuration_id"]
  end

end
