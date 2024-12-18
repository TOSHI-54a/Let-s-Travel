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
    return if recommendations.nil?

    @recommendations = translate_recommendations(recommendations)
    if @recommendations.any? { |r| r.start_with?('Error') }
      handle_error('Some translations failed.')
    else
      if request.format.json?
        render json: { recommendations: @recommendations }, status: :ok
      else
        render :index
      end
    end
  end

  private

  def recommendation_params
    params.require(:travel_search).permit(:number, :gender, :age, :budget)
  end

  def fetch_recommendations(params)
    client = ChatGptClient.new
    result = client.get_recommendations(params)
    return result unless result.is_a?(String) && result.start_with?('Error')

    handle_error(result)
    nil
  end

  def translate_recommendations(recommendations)
    deepl_client = DeepLClient.new(ENV['DEEPL_API_KEY'])
    recommendations.map { |recommendation| deepl_client.translate(recommendation) }
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
