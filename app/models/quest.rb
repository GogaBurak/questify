class Quest < ApplicationRecord
  belongs_to :game_session
  belongs_to :player

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :status, inclusion: { in: %w[in_progress completed failed], message: "%{value} is not a valid status" }
  validates :reward, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :pending, -> { where.(status: :pending) }

  def self.generate_quest(game_session_id:, player_id:)
    target_player = Player.joins(:game_sessions).where(game_sessions: { id: game_session_id }).order("RANDOM()").limit(1).first
    data = QuestGenerator.generate(target_player.name)
    Quest.new(**data, game_session_id:, player_id:)
  end
end
