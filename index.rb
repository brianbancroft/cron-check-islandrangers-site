# frozen_string_literal: true

require 'dotenv/load'
require 'nokogiri'
require 'open-uri'
require 'twilio-ruby'

Dotenv.load('.env')

def send_call(message)
  account_sid = ENV['TWILIO_ACCOUNT_SID']
  auth_token = ENV['TWILIO_AUTH_TOKEN']
  client = Twilio::REST::Client.new(account_sid, auth_token)

  from = '+12062077186' # Your Twilio number
  to = ENV['DESTINATION_PHONE_NUMBER'] # Your mobile phone number

  client.messages.create(
    from: from,
    to: to,
    body: message
  )
end

url = 'https://islandrangers.ca/about/membership-application.html'

html_content = URI.parse(url).open.read

parsed_content = Nokogiri::HTML(html_content)

validation_string = 'Applications for 2023 are now complete'

if parsed_content.text.include? validation_string

  send_call('😴 The application form is not available yet')
else
  send_call('🔥 🚨  The application form is available')
end
