class GameSession < ApplicationRecord
  has_many :quests, dependent: :destroy
  has_and_belongs_to_many :players

  validates :title, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :started_at, presence: true
  validates :duration, presence: true, format: { with: /\A\d{2}:\d{2}:\d{2}\z/, message: "must be in HH:MM:SS format" }
end
