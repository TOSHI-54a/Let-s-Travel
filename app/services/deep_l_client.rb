# frozen_string_literal: true

require 'httparty'
require 'dotenv/load'

class DeepLClient
  include HTTParty

  def initialize(api_key)
    @headers = {
      'Content-Type' => 'application/x-www-form-urlencoded'
    }
    @api_key = api_key
  end

  def translate(text)
    response = self.class.post('https://api-free.deepl.com/v2/translate', headers: @headers, body: {
                                  auth_key: @api_key,
                                  text:,
                                  target_lang: 'JA'
                              })
    parsed_response(response)
  end

  private

  def parsed_response(response)
    if response.success?
      JSON.parse(response.body)['translations'].first['text']

    else
      error_message = begin
        JSON.parse(response.body)['message']
      rescue StandardError
        'Unknown error occurred'
      end
      "Error: Unable to translate. #{error_message}"
    end
  end
end
