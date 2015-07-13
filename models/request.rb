class APIRequest
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
    req = request
    if form.auth_enabled?
      req.basic_auth(form.auth_user, form.auth_pass)
    end
    http.request req
  end

end

class GetRequest < APIRequest
  def request
    uri.query = URI.encode_www_form form.payload
    req = Net::HTTP::Get.new(uri.request_uri)
    req
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

class PatchRequest < APIRequest
  def request
    req = Net::HTTP::Patch.new(uri.request_uri)
    req.body = form.payload.to_json
    req['Content-Type'] = 'application/json'
    req
  end
end
