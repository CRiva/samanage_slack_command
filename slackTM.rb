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

	ticket = {}

	textsplit = params['text'].split(/[,=]/)


	#if !textsplit.any? { |word|  'name'.include?(word)}
	#	respond_message("You didn't give an Incident name, this is the minimum requirement to create a ticket.", params['response_url'])
	#end

	params['text'].split(/[,=]/).each_slice(2) do |a, b|
		key = a.to_s.sub(/^[\s'"]/, "").sub(/[\s'"]$/, "")
		value = b.to_s.sub(/^[\s'"]/, "").sub(/[\s'"]$/, "")
		if key == "requester"
			ticket[key] = {'email': value}
		else
    		ticket[key] = value
    	end
	end

	if ticket['requester'] == nil
		ticket['requester'] = {'email': params['user_name']+"@westmont.edu"}
	end

	if ticket['priority'] == nil
		ticket['priority'] = "Medium"
	end

	incident = {'incident': ticket}
	print incident.to_json


	response = createIncident(incident)

	respond_message(response, params['response_url'])
end

def respond_message(message, url)
	uri = URI.parse(url)
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	header = {'Content-Type': 'application/json'}
	preq = Net::HTTP::Post.new(uri.request_uri, header)
	preq.body = {:text => message, :response_type => 'in_channel'}.to_json
	response = http.request(preq)
	if response.kind_of? Net::HTTPSuccess
		print "Success in posting to Slack"
	else
		print "Something went wrong in posting to slack: #{response.message}"
	end
end

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
	if response.kind_of? Net::HTTPSuccess
		respJson = JSON.parse(response.body)
		print respJson
		return respJson['href'].strip(".json")
	else
		return "Something went wrong: #{response.message}"
	end
end
