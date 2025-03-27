class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authorize_request

  def authorize_request
    return @current_player if defined? @current_player

    token = parse_header cookies[Constants::AUTH_COOKIE]
    begin
      decoded = JsonWebToken.decode token
      @current_player = Player.find decoded[:player_id]
    rescue JWT::DecodeError, JWT::ExpiredSignature, ActiveRecord::RecordNotFound => e
      redirect_to players_url, status: :unauthorized
    end
  end

  def set_current_player
    return unless cookies[Constants::AUTH_COOKIE]
    authorize_request
  end

  private

  def parse_header(header)
    return nil unless header =~ /^Bearer (.+)$/

    Regexp.last_match(1).strip
  end
end
