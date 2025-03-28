require "openai"

class QuestGenerator
  API_KEY = ENV["OPENROUTER_API_KEY"] || Rails.application.credentials.dig(:openrouter, :api_key)

  def self.generate(player_names, language = "english")
    client = OpenAI::Client.new(
      access_token: API_KEY,
      uri_base: "https://openrouter.ai/api/v1"
    )

    response = client.chat(
      parameters: {
        model: "qwen/qwen2.5-vl-32b-instruct:free",
        messages: [
          { role: "system", content: "You are a Minecraft quest master who generates hilarious and chaotic quests. **Respond only in JSON format**." },
          { role: "user", content: "Generate a unique and mischievous Minecraft quest in #{language}. Quest can target players #{player_names.join(", ")}. **Return JSON only** using this structure:\n\n" \
            "{\n" \
            '  "title": "[Funny Quest Title]",' \
            '  "description": "[Hilarious instructions]",' \
            '  "reward": [100-500]' \
            "}\n\n" \
            "Example:\n\n" \
            "{\n" \
            '  "title": "The Great Chicken Flood",' \
            "  \"description\": \"Spawn an army of chickens in PlayerName\'s base until their FPS drops below 10. No mercy.\"," \
            '  "reward": 350' \
            "}\n\n" \
            "Now generate a **new** and **original** quest in JSON format!" }
        ],
        temperature: 0.7,
        top_p: 0.9,
        max_tokens: 150
      }
    )

    parse_response(response)
  end

  def self.parse_response(response)
    content = response.dig("choices", 0, "message", "content")

    JSON.parse(content, symbolize_names: true)
  end
end
