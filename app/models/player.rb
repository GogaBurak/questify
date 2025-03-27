class Player < ApplicationRecord
  has_and_belongs_to_many :game_sessions
  has_many :quests, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
