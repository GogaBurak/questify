class QuestsController < ApplicationController
  before_action :set_quest, only: %i[ show submit discard ]

  # GET /game_sessions/:game_session_id/quests
  # def index
  #   @quests = Quest.pending.where(game_session_id: params[:game_session_id])
  # end

  # GET /game_sessions/:game_session_id/quests/:id
  def show
  end

  # POST /game_sessions/:game_session_id/quests
  def create
    @quest = Quest.generate_quest(game_session_id: params[:game_session_id], player_id: @current_player.id)

    if @quest.save
      flash[:notice] = "Quest was successfully created."
      redirect_back_or_to @quest.game_session
    else
      flash[:alert] = "Something went wrong."
      redirect_back_or_to @quest.game_session
    end
  end

  # PATCH /game_sessions/:game_session_id/quests/:id
  def submit
    ActiveRecord::Base.transaction do
      if @quest.update(status: :completed)
        player = @quest.player
        player.update!(balance: player.balance + @quest.reward)

        flash[:notice] = "Quest was successfully submitted! You earned #{@quest.reward} points."
        redirect_back_or_to @quest.game_session
      else
        flash[:alert] = "Something went wrong."
        redirect_back_or_to @quest.game_session
      end
    end
  rescue => e
    flash[:alert] = "An error occurred: #{e.message}"
    redirect_back_or_to @quest.game_session
  end


  # DELETE /game_sessions/:game_session_id/quests/:id
  def discard
    if @quest.update(status: :discarded)
      flash[:notice] = "Quest was successfully discarded."
      redirect_back_or_to @quest.game_session
    else
      flash[:alert] = "Something went wrong."
      redirect_back_or_to @quest.game_session
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quest
      @quest = Quest.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def quest_params
      params.expect(quest: [ :title, :description, :status, :reward, :game_session_id, :player_id ])
    end
end
