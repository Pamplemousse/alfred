require 'dotenv/load'
require 'sinatra'
require 'twilio-ruby'

require './main.rb'

use Rack::TwilioWebhookAuthentication, ENV['TWILIO_AUTH_TOKEN'], '/mailbox'

run Alfred
