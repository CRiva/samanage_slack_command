#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'

# Disable Sinatra's default Webrick instance
set :run, false

# Include timon.rb, the main webapp script
require './slackTM'
run Sinatra::Application