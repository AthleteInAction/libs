module Hipchat
  
  module_function
  def Message params = {}
    
    @Hipchat = HipchatAPI.new(
      :domain => 'hipchat',
      :subdomain => 'api',
      :token => '5f441af0df8dc7c137269abecec5f3',
      :from => 'MigrationRocket',
      :default_room_id => 'DSC Migration',
      :default_color => 'green'
    )
    
    @Hipchat.Message params
    
  end
  
  
  class HipchatAPI

    # Includes
    # :-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-
    require 'json'
    require 'net/http'
    require 'net/https'
    # :-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-



    # Start Here
    # :-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-
    def initialize params = {}

      @subdomain = params[:subdomain]
      @domain = params[:domain]
      @token = params[:token]
      @message_path = '/v1/rooms/message'
      @from = params[:from]
      @format = 'json'
      @message_format = 'text'
      @notify = 1
      @default_room_id = params[:default_room_id]
      @default_color = params[:default_color]

    end
    # :-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-



    # Post Call
    # :-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-
    def postCall path,params = {}

      http = Net::HTTP.new(@subdomain+'.'+@domain+'.com',443)
      req = Net::HTTP::Post.new(path)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true
      req.set_form_data(params)
      response = http.request(req)
      code = response.code
      body = JSON.parse response.body

      final = {:code => code.to_f.round,:body => body}

    end
    # :-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-



    # Send Message
    # :-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-
    def Message params = {}

      send = {
        :auth_token => @token,
        :format => @format,
        :from => @from,
        :message_format => @message_format,
        :notify => 0,
        :room_id => @default_room_id,
        :color => @default_color
      }

      send = send.merge(params)

      postCall @message_path,send

    end
    # :-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-

  end
  
end