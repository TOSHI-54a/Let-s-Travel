require 'httparty'
require 'dotenv/load'

class DeepLClient
  include HTTParty

  def initialize(api_key)
    @headers = {
      "Content-Type" => "application/x-www-form-urlencoded",
    }
    @api_key = api_key
  end

  def translate(text)
    response = self.class.post('https://api-free.deepl.com/v2/translate', headers: @headers, body: {
      auth_key: @api_key,
      text: text,
      target_lang: 'JA'
    })
    parsed_response(response)
  end

  private

  def parsed_response(response)
    if response.success?
      translation = JSON.parse(response.body)["translations"].first["text"]
      translation
    else
      error_message = JSON.parse(response.body)["message"] rescue "Unknown error occurred"
      "Error: Unable to translate. #{error_message}"
    end
  end
end