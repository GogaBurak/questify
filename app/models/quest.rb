class Quest < ApplicationRecord
  belongs_to :game_session
  belongs_to :player

  scope :pending, -> { where.(status: :pending) }

  def self.generate_quest(game_session_id:, player_id:)
    data = QuestGeneration.generate
    Quest.new(**data, game_session_id:, player_id:)
  end
end
