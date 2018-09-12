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
      'https://edt-st.u-bordeaux.fr/etudiants/Master/Master2/Semestre1/g267729.xml',
      'https://edt-st.u-bordeaux.fr/etudiants/Master/Master1/Semestre1/g267819.xml',
    ].freeze

    schedules.map do |schedule|
      page = Nokogiri::XML(
        open(schedule)
      )

      page.xpath('//event').map do |event|
        week_date = Date.strptime(event[:date], '%d/%m/%Y')
        day_in_week = event.xpath('.//day').text.to_i

        { module: event.xpath('.//module/item').text,
          date: week_date + day_in_week,
          time: event.xpath('.//starttime').text,
          room: event.xpath('.//room/item').text }
      end
    end.flatten
  end
end
