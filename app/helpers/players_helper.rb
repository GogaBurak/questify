module PlayersHelper
  def set_auth_cookie(player_id)
    token = JsonWebToken.encode(player_id: player_id)[:token]

    cookies[Constants::AUTH_COOKIE] = {
      value: "Bearer #{token}",
      expires: 1.year.from_now,
      domain: "localhost" # FIXME
    }
  end

  def delete_auth_cookie
    cookies.delete(Constants::AUTH_COOKIE, domain: "localhost")
  end
end
