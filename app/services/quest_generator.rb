require "openai"

class QuestGenerator
  def self.generate(player_name)
    client = OpenAI::Client.new(
      access_token: Rails.application.credentials.dig(:openrouter, :api_key),
      uri_base: "https://openrouter.ai/api/v1"
    )

    response = client.chat(
      parameters: {
        model: "openai/gpt-4o-search-preview",
        messages: [
          { role: "system", content: "You are a Minecraft quest master who generates hilarious and chaotic quests." },
          { role: "user", content: "Generate a unique and mischievous Minecraft quest targeting player **#{player_name}**. Use this format:\n\n" \
            "Title: [Funny Quest Title]\n" \
            "Description: [Hilarious instructions]\n" \
            "Reward: [100-500]\n\n" \
            "Examples:\n\n" \
            "Title: The Great Chicken Flood\n" \
            "Description: Spawn an army of chickens in #{player_name}'s base until their FPS drops below 10. No mercy.\n" \
            "Reward: 350\n\n" \
            "Title: The Rotten Victory\n" \
            "Description: Defeat #{player_name} in PVP using only rotten flesh. Style points if they rage quit.\n" \
            "Reward: 400\n\n" \
            "Now generate a **new** and **original** quest!" }
        ],
        max_tokens: 150
      }
    )

    parse_response(response)
  end


  def self.parse_response(response)
    content = response.dig("choices", 0, "message", "content")

    if content
      match = content.match(/Title: (.*?)\nDescription: (.*?)\nReward: (\d+)/m)
      if match
        { title: match[1], description: match[2], reward: match[3].to_i }
      else
        { title: "Unknown Quest", description: "AI did not return structured data.", reward: 100 }
      end
    else
      { title: "Error", description: "Failed to get AI response.", reward: 100 }
    end
  end
end
