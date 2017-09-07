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
	print params
end

#def getIncidents(params)
#	uri = URI.parse(@conf['TM_API']['TMIncidentsURL']).tap do |uri|
#		uri.query = URI.encode_www_form params
#	end
#	http = Net::HTTP.new(uri.host, uri.port)
#	http.use_ssl = true
#	header = {'Accept': 'application/json', 'Content-Type': 'application/json'}
#	preq = Net::HTTP::Get.new(uri.request_uri, header)
#
#	user = @conf['TM_API']['TMAdminUser']
#	passwd = @conf['TM_API']['TMAdminPwd']
#	preq.basic_auth(user, passwd)
#	response = http.request(preq)
	#print response.body+"\n"
#	respJson = JSON.parse(response.body)
#	print params.to_s+"\n"
#	print respJson.length().to_s+"\n"
#	return respJson.to_json
#end
