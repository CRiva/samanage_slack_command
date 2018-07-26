require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'inifile'

@conf = IniFile.load('config.ini')
incident = {"incident":{"name": "testing jwt api","requester":{"email": @conf['TM_API']['email']}, "priority": "LOW"}}


def createIncident(incident)
	uri = URI.parse(@conf['TM_API']['TMIncidentsURL'])
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	header = {'Accept': 'application/vnd.samanage.v2.1+json', 
		      'Content-Type': 'application/json',
		      'X-Samanage-Authorization': 'Bearer '+@conf['TM_API']['TMJWT']}
	preq = Net::HTTP::Post.new(uri.request_uri, header)
	preq.body = incident.to_json

	response = http.request(preq)
	respJson = JSON.parse(response.body)
	respJson.length().to_s+"\n"
	print respJson['href'].strip(".json")
end

createIncident(incident)