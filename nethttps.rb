require 'net/http' # Needed for Net::HTTP
require 'uri' # Needed for URI.escape()
require 'json'


@subdomain = 'myphotodynamic'
@path = URI.escape('/api/v2/users.json')
@username = 'will@myphotodynamic.com'
@password = 'Lightning22'


http = Net::HTTP.new(@subdomain+'.zendesk.com',443) # Sets up the host
req = Net::HTTP::Get.new(@path) # Sets up the path
http.verify_mode = OpenSSL::SSL::VERIFY_NONE # Required for HTTPS
http.use_ssl = true # Turn on HTTPS
req.content_type = 'application/json' # Sets content type
req.basic_auth @username,@password # Sets crudentials for Basic Auth
response = http.request(req) # The response
status_code = response.code # Pulling details from the response
response_body = response.body # Pulling details from the response


puts status_code
puts JSON.pretty_generate(JSON.parse(response_body))