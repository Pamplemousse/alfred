require 'nokogiri'
require 'open-uri'

require_relative 'lib/utils'

schedules = [
  'https://edt-st.u-bordeaux.fr/etudiants/Licence/Semestre2/g254486.xml',
  'https://edt-st.u-bordeaux.fr/etudiants/Licence/Semestre2/g299653.xml',
  'https://edt-st.u-bordeaux.fr/etudiants/Licence/Semestre2/g291701.xml'
].freeze

all_sessions = schedules.map do |schedule|
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

my_sessions = followed_sessions(all_sessions)
my_next_sessions = todays_sessions(my_sessions)

puts my_next_sessions.count
