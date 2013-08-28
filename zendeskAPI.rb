class ZendeskAPI
  
  # Includes
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  require 'json'
  require 'net/http'
  require 'net/https'
  require 'uri'
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Set Infrastructure
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def initialize params = {}
    
    @subdomain           = params[:domain]
    @path                = '/api/v2/'
    @username            = params[:username]
    @username           << '/token' if params[:token]
    @password            = params[:password] || params[:token]
    @roles = {
      'end-user' => '0', 0 => '0',
      'admin'    => '2', 2 => '2',
      'agent'    => '4', 4 => '4'
    }
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # GET Call
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def get path
    
    a = Time.now.to_f
    http = Net::HTTP.new(@subdomain+'.zendesk.com',443)
    req = Net::HTTP::Get.new(URI.escape(@path+path))
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    req.content_type = 'application/json'
    req.basic_auth @username,@password
    response = http.request(req)
    code = response.code
    body = response.body
    b = Time.now.to_f
    c = ((b-a)*100).round.to_f/100
    
    final = {:code => code.to_f.round,:body => JSON.parse(body),time: c}
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # POST Call
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def post path,payload
    
    a = Time.now.to_f
    http = Net::HTTP.new(@subdomain+'.zendesk.com',443)
    req = Net::HTTP::Post.new(@path+path)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    req.content_type = 'application/json'
    req.basic_auth @username,@password
    req.body = payload
    response = http.request(req)
    code = response.code
    body = response.body
    b = Time.now.to_f
    c = ((b-a)*100).round.to_f/100
    
    if code.to_f.round == 500
      final = {:code => code.to_f.round,time: c}
    else
      final = {:code => code.to_f.round,:body => JSON.parse(body),time: c}
    end
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # PUT Call
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def put path,payload
    
    a = Time.now.to_f
    http = Net::HTTP.new(@subdomain+'.zendesk.com',443)
    req = Net::HTTP::Put.new(@path+path)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    req.content_type = 'application/json'
    req.basic_auth @username,@password
    req.body = payload
    response = http.request(req)
    code = response.code
    body = response.body
    b = Time.now.to_f
    c = ((b-a)*100).round.to_f/100
    #body = JSON.parse(body) if code.to_f.round = 200
    
    if code.to_f.round == 500
      final = {:code => code.to_f.round,time: c}
    else
      final = {:code => code.to_f.round,:body => JSON.parse(body),time: c}
    end
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # DELETE Call
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def delete path
    
    a = Time.now.to_f
    http = Net::HTTP.new(@subdomain+'.zendesk.com',443)
    req = Net::HTTP::Delete.new(@path+path)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    req.content_type = 'application/json'
    req.basic_auth @username,@password
    response = http.request(req)
    code = response.code
    b = Time.now.to_f
    c = ((b-a)*100).round.to_f/100
    
    final = {:code => code.to_f.round,time: c}
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # UPLOAD Call
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def upload path,payload
    
    a = Time.now.to_f
    http = Net::HTTP.new(@subdomain+'.zendesk.com',443)
    req = Net::HTTP::Post.new(@path+path)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    req.content_type = 'application/binary'
    req.basic_auth @username,@password
    req.body = payload
    response = http.request(req)
    code = response.code
    body = response.body
    b = Time.now.to_f
    c = ((b-a)*100).round.to_f/100
    
    final = {:code => code.to_f.round,:body => JSON.parse(body),time: c}
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  # Users
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def users params = {}
    
    params = params.map{ |key,val| "#{key}=#{val}" }.join('&')
    
    path = "users.json?#{params}"
    
    get path
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # Locales
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def locales params = {}
    
    params = params.map{ |key,val| "#{key}=#{val}" }.join('&')
    
    path = "locales.json?#{params}"
    
    get path
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
end