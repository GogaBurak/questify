class GameSessionsController < ApplicationController
  include GameSessionsHelper

  before_action :set_game_session, only: %i[ show edit update destroy join leave]

  # GET /game_sessions
  def index
    @game_sessions = GameSession.all
  end

  # GET /game_sessions/1
  def show
    @game_session_quest = Quest.find_by(
      status: :in_progress,
      game_session_id: @game_session.id,
      player_id: @current_player
    )
  end

  # GET /game_sessions/new
  def new
    @game_session = GameSession.new
  end

  # GET /game_sessions/1/edit
  def edit
  end

  # POST /game_sessions
  def create
    @game_session = GameSession.new(game_session_params)

    if @game_session.save
      redirect_to @game_session, notice: I18n.t("game_sessions.notice.create_success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /game_sessions/1
  def update
    if @game_session.update(game_session_params)
      redirect_to @game_session, notice: I18n.t("game_sessions.notice.update_success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /game_sessions/1
  def destroy
    @game_session.destroy!

    redirect_to game_sessions_path, status: :see_other, notice: I18n.t("game_sessions.notice.destroy_success")
  end

  # POST /game_sessions/1/join
  def join
    if already_joined?(@game_session)
      flash[:alert] = "Already joined."
      redirect_back_or_to game_session_path(@game_session)
    else
      @game_session.players << @current_player

      flash[:notice] = I18n.t("game_sessions.notice.join_success")
      redirect_back_or_to game_session_path(@game_session)
    end
  end

  # POST /game_sessions/1/leave
  def leave
    if already_joined?(@game_session)
      @game_session.players.delete(@current_player)

      flash[:notice] = I18n.t("game_sessions.notice.leave_success")
      redirect_to game_session_path(@game_session)
    else
      flash[:alert] = I18n.t("game_sessions.alert.not_joined")
      redirect_to game_session_path(@game_session)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_session
      @game_session = GameSession.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def game_session_params
      params.expect(game_session: [ :title, :started_at, :duration ])
    end
end
