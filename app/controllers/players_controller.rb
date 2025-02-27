class PlayersController < ApplicationController
  before_action :set_player, only: %i[ show edit update destroy ]
  skip_before_action :authorize_request, only: %i[index show new create login]

  # GET /players
  def index
    @players = Player.all
  end

  # GET /players/1
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # PATCH/PUT /players/1
  def update
    if @player.update(player_params)
      redirect_to @player, notice: "Player was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # POST /players
  def create
    @player = Player.new(player_params)

    if @player.save
      token = JsonWebToken.encode(player_id: params[:id])[:token]
      cookies[Constants::AUTH_COOKIE] = {
        value: "Bearer #{token}",
        expires: 1.year.from_now,
        domain: "localhost" # FIXME
      }
      redirect_to @player, notice: "Player was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # POST /players/1/login
  def login
    head :bad_request unless params[:id]

    token = JsonWebToken.encode(player_id: params[:id])[:token]
    cookies[Constants::AUTH_COOKIE] = {
      value: "Bearer #{token}",
      expires: 1.year.from_now,
      domain: "localhost" # FIXME
    }
    # binding.pry
    redirect_to game_sessions_url
  end

  def logout
    return head :bad_request unless @current_player

    cookies.delete(Constants::AUTH_COOKIE, domain: "localhost")
    redirect_to players_url
  end

  # DELETE /players/1
  def destroy
    @player.destroy!

    redirect_to players_path, status: :see_other, notice: "Player was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.expect(player: [ :name, :balance ])
    end
end
