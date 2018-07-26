#Samanage Slack Slash Command

A simple sinatra application that allows slack to create a new support ticket using a slash command

## Usage

You will need to have the sinatra app running and the slash command set up in your slack custom integrations using the url for your sinatra app, a `POST` method and the name of the slash command (I used `/ticket`).

You will also need to set up a config.ini file within the directory with the following attributes:
```
[TM_API]
TMIncidentsURL = https://api.samanage.com/incidents.json
TMJWT = <Your JWT given by samanage>
admin_email = user@domain.com
domain = domain.com
support_site = domain.samanage.com (or your custom support url if you have one)
```

From slack, you can use the command as follows:

`/ticket name = "Title for ticket", description = "Description for ticket", requester = user@domain.com, priority = Low`

`name` is the only required attribute for the ticket creation, the command can pull your username from slack if you set up a domain in a config.ini file. 

## Development

To install required gems run `bundle install`

You can have the site start via Phusion Passenger, or run the `config.ru` file to start the site. 

You can use the command via `POST` request to `/` and `params['text']` is where the ticket information needs to be.

## Contributing

Bug reports and pull requests are welcome on [Bitbucket](https://bitbucket.org/westmont/slacktm/src) or [Github](https://github.com/CRiva/samanage_slack_command).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
