require 'httparty'
require 'dotenv/load'

class ChatGptClient
# ここでclassをChatGPTClientとするとうまく読み込めないエラーが発生する。Zeitwerkの関係からファイル名とクラス名が対応する必要あり。
# コントローラーcreateとも統一する
  include HTTParty

  def initialize
    @headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{ENV['CHATGPT_API_KEY']}"
    }
  end

  def get_recommendations(params)
    body = {
        model: "gpt-3.5-turbo",
        messages: [
            { role: "system", content: "You are a helpful travel assistant." },
            { role: "user", content: generate_prompt(params) }
        ],
        max_tokens: 150,
        temperature: 0.7
    }.to_json

    response = self.class.post('https://api.openai.com/v1/chat/completions', headers: @headers, body: body)
    parsed_response(response)
  end

  private

  def generate_prompt(params)
    "Recommend 3 travel destinations for a group of #{params[:number]} #{params[:gender]} aged #{params[:age]} with a budget of #{params[:budget]}. Provide the city names and a brief description of each."
  end

  def parsed_response(response)
    if response.success?
      recommendations = JSON.parse(response.body)["choices"].first["message"]["content"]
      format_recommendations(recommendations)
    else
      error_message = JSON.parse(response.body)["error"]["message"] rescue "Unknown error occurred"
      "Error: Unable to fetch recommendations. #{error_message}"
    end
  end

  def format_recommendations(recommendations)
    recommendations.split("\n").map(&:strip).reject(&:empty?)
  end
end