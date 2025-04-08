class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authorize_request
  before_action :set_locale

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

  # Handle locale switch
  def default_url_options
    if I18n.locale != I18n.default_locale
      { locale: I18n.locale }
    else
      {}
    end
  end

  private

  def parse_header(header)
    return nil unless header =~ /^Bearer (.+)$/

    Regexp.last_match(1).strip
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
