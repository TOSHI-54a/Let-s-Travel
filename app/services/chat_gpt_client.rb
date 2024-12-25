# frozen_string_literal: true

require 'httparty'
require 'dotenv/load'

class ChatGptClient
  # ここでclassをChatGPTClientとするとうまく読み込めないエラーが発生する。Zeitwerkの関係からファイル名とクラス名が対応する必要あり。
  # コントローラーcreateとも統一する
  include HTTParty

  def initialize
    @headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{ENV['CHATGPT_API_KEY']}"
    }
  end

  def get_recommendations(params)
    body = {
      model: 'gpt-3.5-turbo',
      messages: [
        { role: 'system', content: 'You are a helpful travel assistant for Japanese travelers.' },
        { role: 'user', content: generate_prompt(params) }
      ],
      max_tokens: 150,
      temperature: 0.7
    }.to_json

    response = self.class.post('https://api.openai.com/v1/chat/completions', headers: @headers, body:)
    parsed_response(response)
  end

  private

  def generate_prompt(params)
    departure = params[:departure] || 'Tokyo'
    hobby = params[:hobby] ? " Their hobby is #{params[:hobby]}." : ''
    "Recommend 3 #{params[:in_or_out]} travel destinations for a group of #{params[:number]} " \
    "#{params[:gender]} aged #{params[:age]} with a budget of #{params[:budget]}JPY. "\
    "The departure point is #{departure}.#{hobby} Provide the city names and a brief description of each."
  end

  def parsed_response(response)
    if response.success?
      recommendations = JSON.parse(response.body)['choices'].first['message']['content']
      format_recommendations(recommendations)
    else
      error_message = begin
        JSON.parse(response.body)['error']['message']
      rescue StandardError
        'Unknown error occurred'
      end
      "Error: Unable to fetch recommendations. #{error_message}"
    end
  end

  def format_recommendations(recommendations)
    recommendations.split("\n").map(&:strip).reject(&:empty?)
  end
end
