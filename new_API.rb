module ZendeskAPI
  
  # Includes
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  require 'json'
  require 'net/http'
  require 'net/https'
  require 'uri'
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  class Connect
    
    
    # Set Infrastructure
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    def initialize params = {}

      @infra = {
        domain: params[:domain],
        path: '/api/v2/',
        username: params[:username].to_s,
        authentication: params[:password] || params[:token],
        roles: {
          'end-user' => '0', 0 => '0',
          'admin'    => '2', 2 => '2',
          'agent'    => '4', 4 => '4'
        }
      }

      @infra[:username] << '/token' if params[:token]
      
      @api = 0

    end
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # Access
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    def APICount
      @api
    end
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # API Call
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    def APICall params = {}
      
      path = params[:path]
      method = params[:method] || 'GET'
      payload = params[:payload] || nil
      
      params.delete(:method)
      params.delete(:path)
      params.delete(:payload)
      
      a = Time.now.to_f
      
      http = Net::HTTP.new(@infra[:domain]+'.zendesk.com',443)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true
      
      uri = %{#{@infra[:path]}#{path}}
      uri << '?'+params.map{ |key,val| "#{key}=#{val}" }.join('&') if params && params.count > 0
      uri = URI.escape uri
      
      reqs = {
        'GET' => Net::HTTP::Get.new(uri),
        'POST' => Net::HTTP::Post.new(uri),
        'PUT' => Net::HTTP::Put.new(uri),
        'DELETE' => Net::HTTP::Delete.new(uri)
      }
      req = reqs[method]
      
      content_type = 'application/json'
      content_type = 'application/binary' if path.include? 'uploads'
      req.content_type = content_type
      
      req.basic_auth @infra[:username],@infra[:authentication]
      
      req.body = payload if method == 'POST' || method == 'PUT'
      
      response = http.request req
      
      code = response.code.to_f.round
      body = response.body
      
      b = Time.now.to_f
      c = ((b-a)*100).round.to_f/100
      
      final = {code: code}
      final = final.merge(body: JSON.parse(body)) if method != 'DELETE' && code != 500
      final = final.merge(time: c)
      
      @api += 1
      
      final
      
    end
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # GET Call
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    def GETCall url
      
      a = Time.now.to_f
      
      uri = URI.parse url
      
      http = Net::HTTP.new(uri.host,443)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true if uri.scheme == 'https'
      req = Net::HTTP::Get.new uri.path
      response = http.request req
      code = response.code.to_f.round
      body = response.body
      
      b = Time.now.to_f
      c = ((b-a)*100).round.to_f/100
      
      final = {code: code}
      final = final.merge(body: body)
      final = final.merge(time: c)
      
      final
      
    end
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # Users
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
      
      # GET Users
      # ===================================================
      def GetUsers params = {}

        params = params.merge(path: 'users.json')
        APICall(params)

      end
      # ===================================================
      # GET User
      # ===================================================
      def GetUser id

        APICall(path: "users/#{id}.json")

      end
      # ===================================================
      # CREATE User
      # ===================================================
      def CreateUser params = {}
        
        APICall(path: 'users.json',method: 'POST',payload: params.to_json)
        
      end
      # ===================================================
      # UPDATE User
      # ===================================================
      def UpdateUser params = {}
        
        APICall(path: 'users.json',method: 'PUT',payload: params.to_json)
        
      end
      # ===================================================
      # DELETE User
      # ===================================================
      def DeleteUser id
        
        APICall(path: "users/#{id}.json",method: 'DELETE')
        
      end
      # ===================================================
      
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # Organizations
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
      
      # GET Organizations
      # ===================================================
      def GetOrgs params = {}

        params = params.merge(path: 'organizations.json')
        APICall(params)

      end
      # ===================================================
      # GET Organization
      # ===================================================
      def GetOrg id

        APICall(path: "organizations/#{id}.json")

      end
      # ===================================================
      # CREATE Organization
      # ===================================================
      def CreateOrganization params = {}
        
        APICall(path: 'organizations.json',method: 'POST',payload: params.to_json)
        
      end
      def CreateOrg params = {}
        
        APICall(path: 'organizations.json',method: 'POST',payload: params.to_json)
        
      end
      # ===================================================
      # UPDATE Organization
      # ===================================================
      def UpdateOrganization params = {}
        
        APICall(path: 'organizations.json',method: 'PUT',payload: params.to_json)
        
      end
      # ===================================================
      # DELETE Organization
      # ===================================================
      def DeleteOrganization id
        
        APICall(path: "organizations/#{id}.json",method: 'DELETE')
        
      end
      # ===================================================
      # ===================================================
      def DeleteOrg id
        
        APICall(path: "organizations/#{id}.json",method: 'DELETE')
        
      end
      # ===================================================
      
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # Groups
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
      
      # GET Groups
      # ===================================================
      def GetGroups params = {}

        params = params.merge(path: 'groups.json')
        APICall(params)

      end
      # ===================================================
      # GET Group
      # ===================================================
      def GetGroup id

        APICall(path: "groups/#{id}.json")

      end
      # ===================================================
      # CREATE Group
      # ===================================================
      def CreateGroup params = {}
        
        APICall(path: 'groups.json',method: 'POST',payload: params.to_json)
        
      end
      # ===================================================
      # UPDATE Group
      # ===================================================
      def UpdateGroup params = {}
        
        APICall(path: 'groups.json',method: 'PUT',payload: params.to_json)
        
      end
      # ===================================================
      # DELETE Group
      # ===================================================
      def DeleteGroup id
        
        APICall(path: "groups/#{id}.json",method: 'DELETE')
        
      end
      # ===================================================
      
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # Categories
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
      
      # GET Categories
      # ===================================================
      def GetCategories params = {}

        params = params.merge(path: 'categories.json')
        APICall(params)

      end
      def GetCats params = {}

        params = params.merge(path: 'categories.json')
        APICall(params)

      end
      # ===================================================
      # GET Category
      # ===================================================
      def GetCategory id

        APICall(path: "categories/#{id}.json")

      end
      # ===================================================
      # CREATE Category
      # ===================================================
      def CreateCategory params = {}
        
        APICall(path: 'categories.json',method: 'POST',payload: params.to_json)
        
      end
      def CreateCat params = {}
        
        APICall(path: 'categories.json',method: 'POST',payload: params.to_json)
        
      end
      # ===================================================
      # UPDATE Category
      # ===================================================
      def UpdateCategory params = {}
        
        APICall(path: 'categories.json',method: 'PUT',payload: params.to_json)
        
      end
      # ===================================================
      # DELETE Category
      # ===================================================
      def DeleteCategory id
        
        APICall(path: "categories/#{id}.json",method: 'DELETE')
        
      end
      # ===================================================
      
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # Forums
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
      
      # GET Forums
      # ===================================================
      def GetForums params = {}

        params = params.merge(path: 'forums.json')
        APICall(params)

      end
      # ===================================================
      # GET Forum
      # ===================================================
      def GetForum id

        APICall(path: "forums/#{id}.json")

      end
      # ===================================================
      # CREATE Forum
      # ===================================================
      def CreateForum params = {}
        
        APICall(path: 'forums.json',method: 'POST',payload: params.to_json)
        
      end
      # ===================================================
      # UPDATE Forum
      # ===================================================
      def UpdateForum params = {}
        
        APICall(path: 'forums.json',method: 'PUT',payload: params.to_json)
        
      end
      # ===================================================
      # DELETE Forum
      # ===================================================
      def DeleteForum id
        
        APICall(path: "forums/#{id}.json",method: 'DELETE')
        
      end
      # ===================================================
      
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # Topics
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
      
      # GET Topics
      # ===================================================
      def GetTopics params = {}

        params = params.merge(path: 'topics.json')
        APICall(params)

      end
      # ===================================================
      # GET Topics by Forum ID
      # ===================================================
      def GetTopicsByForum id,params = {}

        params = params.merge(path: "forums/#{id}/topics.json")
        APICall(params)

      end
      # ===================================================
      # GET Topic
      # ===================================================
      def GetTopic id

        APICall(path: "topics/#{id}.json")

      end
      # ===================================================
      # CREATE Topic
      # ===================================================
      def CreateTopic params = {}
        
        APICall(path: 'topics.json',method: 'POST',payload: params.to_json)
        
      end
      # ===================================================
      # UPDATE Topic
      # ===================================================
      def UpdateTopic id,params = {}
        
        APICall(path: "topics/#{id}.json",method: 'PUT',payload: params.to_json)
        
      end
      # ===================================================
      # DELETE Topic
      # ===================================================
      def DeleteTopic id
        
        APICall(path: "topics/#{id}.json",method: 'DELETE')
        
      end
      # ===================================================
      
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # Locales
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
      
      # GET Locales
      # ===================================================
      def GetLocales params = {}

        params = params.merge(path: 'locales.json')
        APICall(params)

      end
      # ===================================================
      # GET Locale
      # ===================================================
      def GetLocale id

        APICall(path: "locales/#{id}.json")

      end
      # ===================================================
      # CREATE Locale
      # ===================================================
      def CreateLocale params = {}
        
        APICall(path: 'locales.json',method: 'POST',payload: params.to_json)
        
      end
      # ===================================================
      # UPDATE Locale
      # ===================================================
      def UpdateLocale params = {}
        
        APICall(path: 'locales.json',method: 'PUT',payload: params.to_json)
        
      end
      # ===================================================
      # DELETE Locale
      # ===================================================
      def DeleteLocale id
        
        APICall(path: "locales/#{id}.json",method: 'DELETE')
        
      end
      # ===================================================
      
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # Roles
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
      
      # GET Roles
      # ===================================================
      def GetRoles params = {}

        params = params.merge(path: 'custom_roles.json')
        APICall(params)

      end
      # ===================================================
      # GET Role
      # ===================================================
      def GetRole id

        APICall(path: "custom_roles/#{id}.json")

      end
      # ===================================================
      # CREATE Role
      # ===================================================
      def CreateRole params = {}
        
        APICall(path: 'custom_roles.json',method: 'POST',payload: params.to_json)
        
      end
      # ===================================================
      # UPDATE Role
      # ===================================================
      def UpdateRole params = {}
        
        APICall(path: 'custom_roles.json',method: 'PUT',payload: params.to_json)
        
      end
      # ===================================================
      # DELETE Role
      # ===================================================
      def DeleteRole id
        
        APICall(path: "custom_roles/#{id}.json",method: 'DELETE')
        
      end
      # ===================================================
      
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # Triggers
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
      
      # GET Triggers
      # ===================================================
      def GetTriggers params = {}

        params = params.merge(path: 'triggers.json')
        APICall(params)

      end
      # ===================================================
      # GET Trigger
      # ===================================================
      def GetTrigger id

        APICall(path: "triggers/#{id}.json")

      end
      # ===================================================
      # CREATE Trigger
      # ===================================================
      def CreateTrigger params = {}
        
        APICall(path: 'triggers.json',method: 'POST',payload: params.to_json)
        
      end
      # ===================================================
      # UPDATE Trigger
      # ===================================================
      def UpdateTrigger id,params = {}
        
        APICall(path: "triggers/#{id}.json",method: 'PUT',payload: params.to_json)
        
      end
      # ===================================================
      # DELETE Trigger
      # ===================================================
      def DeleteTrigger id
        
        APICall(path: "triggers/#{id}.json",method: 'DELETE')
        
      end
      # ===================================================
      
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # Ticket Fields
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
      
      # GET Fields
      # ===================================================
      def GetFields params = {}

        params = params.merge(path: 'ticket_fields.json')
        APICall(params)

      end
      # ===================================================
      # GET Role
      # ===================================================
      def GetField id

        APICall(path: "ticket_fields/#{id}.json")

      end
      # ===================================================
      # CREATE Role
      # ===================================================
      def CreateField params = {}
        
        APICall(path: 'ticket_fields.json',method: 'POST',payload: params.to_json)
        
      end
      # ===================================================
      # UPDATE Role
      # ===================================================
      def UpdateField params = {}
        
        APICall(path: 'ticket_fields.json',method: 'PUT',payload: params.to_json)
        
      end
      # ===================================================
      # DELETE Role
      # ===================================================
      def DeleteField id
        
        APICall(path: "ticket_fields/#{id}.json",method: 'DELETE')
        
      end
      # ===================================================
      
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # Tickets
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
      
      # GET Tickets
      # ===================================================
      def GetTickets params = {}

        params = params.merge(path: 'tickets.json')
        APICall(params)

      end
      # ===================================================
      # GET Ticket Audits
      # ===================================================
      def GetTicketAudits id,params = {}

        params = params.merge(path: "tickets/#{id}/audits.json")
        APICall(params)

      end
      # ===================================================
      # GET Ticket
      # ===================================================
      def GetTicket id

        APICall(path: "tickets/#{id}.json")

      end
      # ===================================================
      # CREATE Ticket
      # ===================================================
      def CreateTicket params = {}
        
        APICall(path: 'imports/tickets.json',method: 'POST',payload: params.to_json)
        
      end
      # ===================================================
      # UPDATE Ticket
      # ===================================================
      def UpdateTicket params = {}
        
        APICall(path: 'tickets.json',method: 'PUT',payload: params.to_json)
        
      end
      # ===================================================
      # DELETE Ticket
      # ===================================================
      def DeleteTicket id
        
        APICall(path: "tickets/#{id}.json",method: 'DELETE')
        
      end
      # ===================================================
      
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # Ticket Comments
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
      
      # GET Comments
      # ===================================================
      def GetComments id,params = {}

        params = params.merge(path: "tickets/#{id}/comments.json")
        APICall(params)

      end
      # ===================================================
      
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    
    # Group Memberships
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
      
      # GET Memberships
      # ===================================================
      def GetMemberships params = {}

        params = params.merge(path: 'group_memberships.json')
        APICall(params)

      end
      # ===================================================
      # GET Membership
      # ===================================================
      def GetMembership id

        APICall(path: "group_memberships/#{id}.json")

      end
      # ===================================================
      # CREATE Membership
      # ===================================================
      def CreateMembership params = {}
        
        APICall(path: 'group_memberships.json',method: 'POST',payload: params.to_json)
        
      end
      # ===================================================
      # UPDATE Membership
      # ===================================================
      def UpdateMembership params = {}
        
        APICall(path: 'group_memberships.json',method: 'PUT',payload: params.to_json)
        
      end
      # ===================================================
      # DELETE Membership
      # ===================================================
      def DeleteMembership id
        
        APICall(path: "group_memberships/#{id}.json",method: 'DELETE')
        
      end
      # ===================================================
      
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
    
    # Upload Files
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
      
      # UPLOAD File
      # ===================================================
      def Upload file
        
        APICall(path: "uploads.json?filename=#{file.split('/').last}",method: 'POST',payload: File.read(file))
        
      end
      # ===================================================
    
    #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:

  end
  
end

=begin
Zendesk = ZendeskAPI::Connect.new(
  domain: 'myphotodynamic1373328904',
  username: 'will@myphotodynamic.com',
  password: 'Lightning22'
)
=end