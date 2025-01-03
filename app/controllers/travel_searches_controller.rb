# frozen_string_literal: true

class TravelSearchesController < ApplicationController
  skip_before_action :require_login, only: %i[new index create]

  def new
    @travel_search = TravelSearch.new
  end

  def index
    @query = search_params
  end

  def create
    @travel_search = TravelSearch.new(recommendation_params)

    unless @travel_search.valid?
      handle_error('Please fill in all the required fields')
      return
    end

    recommendations = fetch_recommendations(recommendation_params)
    Rails.logger.debug { "REEEEE: #{recommendations}" }
    return if recommendations.nil?

    translated_recommendations = translate_recommendations(recommendations)
    if request.format.json?
      render json: { recommendations: translated_recommendations }, status: :ok
    else
      @recommendations = translated_recommendations
      Rails.logger.debug { "Recommendations: #{@recommendations}" }
      render :index
    end
  end

  private

  def recommendation_params
    params.require(:travel_search).permit(:number, :gender, :age, :budget, :in_or_out, :departure, :hobby)
  end

  def fetch_recommendations(params)
    client = ChatGptClient.new
    result = client.get_recommendations(params)

    if result.is_a?(String) && result.start_with?('Error')
      handle_error(result)
      nil
    else
      format_recommendations(result)
    end
  end

  def format_recommendations(recommendations)
    # JSONレスポンスをパースし、期待される形式で返す
    recommendations = recommendations.gsub(/```json|```/, '')
    parsed_recommendations = begin
      JSON.parse(recommendations)
    rescue StandardError
      []
    end
    parsed_recommendations.map do |recommendation|
      if recommendation['city'] && recommendation['description']
        { city: recommendation['city'], description: recommendation['description'] }
      else
        { city: 'Unknown', description: 'Invalid recommendation format' }
      end
    end
  end

  def translate_recommendations(recommendations)
    deepl_client = DeepLClient.new(ENV['DEEPL_API_KEY'])
    recommendations.map do |recommendation|
      translated_city = deepl_client.translate(recommendation[:city])
      translated_description = deepl_client.translate(recommendation[:description])
      { city: translated_city, description: translated_description }
    rescue StandardError => e
      { city: recommendation[:city], description: "Translation error: #{e.message}" }
    end
  end

  def handle_error(message)
    if request.format.json?
      render json: { error: message }, status: :unprocessable_entity
    else
      flash[:error] = message
      render :new
    end
  end
end
