module GameSessionsHelper
  def already_joined?
    @game_session.players.include? @current_player
  end
end
