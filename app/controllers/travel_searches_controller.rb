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

    if @travel_search.valid?
      client = ChatGptClient.new
      recommendations = client.get_recommendations(recommendation_params)

      if @recommendations.is_a?(String) && recommendations.start_with?('Error')
        flash[:error] = recommendations
        render :new
      else
        deepl_client = DeepLClient.new(ENV['DEEPL_API_KEY'])
        @recommendations = recommendations.map do |recommendation|
          deepl_client.translate(recommendation)
        end

        if @recommendations.any? { |r| r.start_with?('Error') }
          flash[:error] = 'Some translations failed.'
          render :new
        else
          render :index
        end
      end
    else
      flash[:error] = 'Please fill in all the required fields'
      render :new
    end
  end

  private

  def recommendation_params
    params.require(:travel_search).permit(:number, :gender, :age, :budget)
  end

  def search_params
    params.permit(:number, :gender, :age, :budget)
  end
end
