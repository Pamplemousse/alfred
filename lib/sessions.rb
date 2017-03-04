class Sessions
  # Returns the sessions that I am interested in
  def self.followed(all_sessions)
    modules = [
      '4TPM201U', # algebre lineaire
      '4TPM206U', # initiation a la programmation en C
      '4TMQ401U', # structures algebriques 1
      '4TTI603U', # arithmetique et crypto
      '4TTI601U', # codes correcteurs
    ].freeze

    all_sessions.select do |session|
      session_code = /\w*/.match(session[:module]).to_s
      modules.include?(session_code)
    end
  end

  # Returns the next session
  def self.next(sessions)
    sessions.select do |session|
      day, month, year = session[:date].split('/')
        .map(&:to_i)
      hours, minutes = session[:time].split(':')

      session_time = Time.local(year, month, day, hours, minutes)
      current_time = Time.now

      session_time > current_time
    end.first
  end

  # Returns the sessions happening the current day
  def self.todays(sessions)
    sessions.select do |session|
      day, month, year = session[:date].split('/')
        .map(&:to_i)
      Date.new(year, month, day) == Date.today
    end
  end
end
