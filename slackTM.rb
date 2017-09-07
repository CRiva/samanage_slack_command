require 'rubygems'
require 'sinatra'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'inifile'

#curl -H "X-Samanage-Authorization: Bearer <token>" -d 
#'{"incident":{"name":"testing jwt api","requester":{"email":"criva@westmont.edu"}, "priority":"LOW"}}' 
#-H 'Accept: application/vnd.samanage.v2.1+json' 
#-H 'Content-Type:application/json' 
#-X POST https://api.samanage.com/incidents.json


before do
	@conf = IniFile.load('config.ini')
end

post '/' do

	ticket = {'incident':{}}

	params[text].split(/[,=]/).each_slice(2) do |a, b|
    	ticket['incident'][a.to_s.sub(/^[\s'"]/, "").sub(/[\s'"]$/, "")] = b.to_s.sub(/^[\s'"]/, "").sub(/[\s'"]$/, "")
	end

	response = createIncident ticket

	respond_message response
end

def respond_message message
  content_type :json
  {:text => message}.to_json
end

def createIncident(format)
	uri = URI.parse(@conf['TM_API']['TMIncidentsURL']).tap do |uri|
		uri.query = URI.encode_www_form format
	end
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	header = {'Accept': 'application/vnd.samanage.v2.1+json', 
		      'Content-Type': 'application/json',
		      'X-Samanage-Authorization': 'Bearer '+@conf['TM_API']['TMJWT']}
	preq = Net::HTTP::Post.new(uri.request_uri, header)

#	user = @conf['TM_API']['TMAdminUser']
#	passwd = @conf['TM_API']['TMAdminPwd']
#	preq.basic_auth(user, passwd)
	response = http.request(preq)
	print response.body+"\n"
	respJson = JSON.parse(response.body)
	respJson.length().to_s+"\n"
	return respJson.to_json['href']
end
