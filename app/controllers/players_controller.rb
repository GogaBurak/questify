class PlayersController < ApplicationController
  before_action :set_player, only: %i[ show edit update destroy ]

  # GET /players or /players.json
  def index
    @players = Player.all
  end

  # GET /players/1 or /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players or /players.json
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        cookies[:player] = @player.name

        format.html { redirect_to @player, notice: "Player was successfully created." }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def login
    render status: :bad_request unless params[:player]

    cookies[:player] = params[:player]
    redirect_to sessions_url, notice: "Successfully logged in."
    # format.json { render :show, status: :created, location: @player }
  end

  def logout
    cookies.delete :player

    redirect_to :action => "index", notice: "Successfully logged out."
  end

  # PATCH/PUT /players/1 or /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: "Player was successfully updated." }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1 or /players/1.json
  def destroy
    @player.destroy!

    respond_to do |format|
      format.html { redirect_to players_path, status: :see_other, notice: "Player was successfully destroyed." }
      format.json { head :no_content }
    end
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
