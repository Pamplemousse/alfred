require_relative 'sessions'

class Messenger
  def initialize(content, sessions)
    @match = /current|next/i.match(content)
                            .to_s
                            .downcase
    @all_sessions = sessions
  end

  def message
    unless @match == ""
      session = Sessions.send(@match.to_sym, @all_sessions)
      if session
        "#{session[:time]}: #{session[:module]}, #{session[:room]}"
      end
    end || ""
  end
end
