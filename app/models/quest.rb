class Quest < ApplicationRecord
  belongs_to :game_session
  belongs_to :player

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :status, inclusion: { in: %w[in_progress completed discarded], message: "%{value} is not a valid status" }
  validates :reward, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :pending, -> { where.(status: :pending) }

  def self.generate_quest_data(game_session, player)
    target_players = game_session.players.where.not(id: player.id).pluck(:name)
    QuestGenerator.generate(target_players)
  end
end
