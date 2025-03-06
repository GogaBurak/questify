class QuestGeneration
  def self.generate # TODO: integrate AI
    count = Quest.count + 1

    {
      title: "Title #{count}",
      description: "Description #{count}",
      reward: 100
    }
  end
end
