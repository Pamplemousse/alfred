class Sessions
  # Returns the current session
  def self.current(sessions)
    sessions.select do |session|
      day = session[:date].day
      month = session[:date].month
      year = session[:date].year
      hours, minutes = session[:time].split(':')

      session_time = Time.local(year, month, day, hours, minutes)
      current_time = Time.now

      # a session last for 1h20 minutes
      session_duration = (60 + 20) * 60

      session_time < current_time &&
        session_time + session_duration > current_time
    end.first
  end

  # Returns the sessions that I am interested in
  def self.followed(all_sessions)
    modules = [
      '4TIN911U', # securite des reseaux
      '4TCY903U', # cryptologie avancee
      '4TCY902U', # cryptanalyse
      '4TIN907U', # verification de logiciels
      '4TMA901U', # algorithmique arithmetique
      '4TCY701U', # theorie de la complexite
    ].freeze

    all_sessions.select do |session|
      session_code = /\w*/.match(session[:module]).to_s
      modules.include?(session_code)
    end
  end

  # Returns the next session
  def self.next(sessions)
    sessions.select do |session|
      day = session[:date].day
      month = session[:date].month
      year = session[:date].year
      hours, minutes = session[:time].split(':')

      session_time = Time.local(year, month, day, hours, minutes)
      current_time = Time.now

      session_time > current_time
    end.first
  end

  # Returns the sessions happening the current day
  def self.todays(sessions)
    sessions.select do |session|
      day = session[:date].day
      month = session[:date].month
      year = session[:date].year

      Date.new(year, month, day) == Date.today
    end
  end
end
