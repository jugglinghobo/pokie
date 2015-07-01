class APIRequest
  USERNAME = 'pokie'
  PASSWORD = '12345'
  attr_accessor :form
  def initialize(form)
    @form = form
  end

  def uri
    @uri ||= URI.parse "#{form.host}#{form.endpoint}"
  end

  def http
    @http ||= Net::HTTP.new uri.host, uri.port
  end

  def submit
    http.request request
  end
end

class GetRequest < APIRequest
  def request
    uri.query = URI.encode_www_form form.payload
    req = Net::HTTP::Get.new(uri.request_uri)
    req.basic_auth(USERNAME, PASSWORD)
    req
  end
end

class PostRequest < APIRequest
  def request
    req = Net::HTTP::Post.new(uri.request_uri)
    req.body = form.payload.to_json
    req.basic_auth(USERNAME, PASSWORD)
    req['Content-Type'] = 'application/json'
    req
  end
end

