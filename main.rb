require 'nokogiri'
require 'open-uri'
require 'sinatra/base'
require 'sinatra/reloader'
require 'twilio-ruby'

require 'pry-byebug' unless Sinatra::Base.production?

require_relative 'lib/sessions'
require_relative 'lib/messenger'

class Alfred < Sinatra::Base
  configure :development do
    Sinatra::Application.reset!
    register Sinatra::Reloader
  end

  get '/' do
    "Good morning' Sir.
     #{Time.now}"
  end

  get '/sessions' do
    @sessions = all_sessions
    "#{@sessions}"
  end

  post '/mailbox' do
    content_type 'text/xml'

    sender = params[:From]
    content = params[:Body]

    if sender == ENV['PHONE_NUMBER']
      sessions = Sessions.todays(
        Sessions.followed(all_sessions)
      )
      message = Messenger.new(content, sessions).message

      unless message.empty?
        response = Twilio::TwiML::Response.new do |r|
          r.Message(message)
        end
        response.to_xml
      end
    end
  end

  private

  def all_sessions
    schedules = [
      'https://edt-st.u-bordeaux.fr/etudiants/Licence/Semestre2/g254486.xml',
      'https://edt-st.u-bordeaux.fr/etudiants/Licence/Semestre2/g299653.xml',
      'https://edt-st.u-bordeaux.fr/etudiants/Licence/Semestre2/g291701.xml'
    ].freeze

    schedules.map do |schedule|
      page = Nokogiri::XML(
        open(schedule)
      )

      page.xpath('//event').map do |event|
        { module: event.xpath('.//module/item').text,
          date: event[:date],
          time: event.xpath('.//starttime').text,
          room: event.xpath('.//room/item').text }
      end
    end.flatten
  end
end
