class PlayersController < ApplicationController
  include PlayersHelper

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
      set_auth_cookie(@player.id)
      redirect_to @player, notice: "Player was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # POST /players/1/login
  def login
    set_auth_cookie(params[:id])

    flash[:notice] = "Successfully logged in."
    redirect_back_or_to game_sessions_url
  end

  # DELETE /logout
  def logout
    delete_auth_cookie

    flash[:notice] = "Successfully logged out."
    redirect_back_or_to game_sessions_url
  end

  # DELETE /players/1
  def destroy
    return head :unauthorized unless @player.id == @current_player.id
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
