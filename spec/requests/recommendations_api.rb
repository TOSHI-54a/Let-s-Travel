require 'rails_helper'
require 'webmock/rspec'

RSpec.describe "Travel Searches API", type: :request do
    describe "POST /travel_searches" do
      let(:valid_params) do
        {
          travel_search: {
            age: 25,
            number: 4,
            gender: "individuals",
            budget: 150000
          }
        }
      end

      let(:deepl_response_body) do
        { translations: [{ text: "ハワイ: 美しいビーチ" }] }.to_json
      end

      let(:deepl_error_response) do
        { message: "Some error message" }.to_json
      end
  
      before do
        expect(ENV['DEEPL_API_KEY']).to_not be_nil
        # ChatGPT APIのモック
        stub_request(:post, "https://api.openai.com/v1/chat/completions")
          .to_return(
            status: 200,
            body: {
              choices: [
                {
                  message: {
                    content: "Hawaii: Beautiful beaches.\nBali: Affordable adventures.\nKyoto: Rich history."
                  }
                }
              ]
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        # DeepL APIのモック (成功時)
        stub_request(:post, "https://api-free.deepl.com/v2/translate")
            .with(
            body: hash_including({
                "auth_key" => ENV['DEEPL_API_KEY'],
                "text" => "Hawaii: Beautiful beaches.",
                "target_lang" => "JA"
            }),
            headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
            )
            .to_return(
                status: 200,
                body: deepl_response_body,
                headers: { 'Content-Type' => 'application/json' }
            )

        # DeepL APIのモック (エラー時)
        stub_request(:post, "https://api-free.deepl.com/v2/translate")
            .with(
            body: hash_including({
                "auth_key" => ENV['DEEPL_API_KEY'],
                "text" => "Some invalid text",
                "target_lang" => "JA"
            }),
            headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
            )
            .to_return(
                status: 400,
                body: deepl_error_response,
                headers: { 'Content-Type' => 'application/json' }
            )
      end

      it "returns translated text on success" do
        client = DeepLClient.new(ENV['DEEPL_API_KEY'])
        translated_text = client.translate("Hawaii: Beautiful beaches.")
        expect(translated_text).to eq("ハワイ: 美しいビーチ")
      end
  
      it "returns an error message on failure" do
        client = DeepLClient.new(ENV['DEEPL_API_KEY'])
        translated_text = client.translate("Some invalid text")
        expect(translated_text).to start_with("Error: Unable to translate.")
      end

      context "with valid parameters" do
        it "returns travel recommendations" , skip: "This test is not ready yet" do
          post travel_searches_path, params: valid_params, as: :json
  
          # ステータスコードの確認
          expect(response).to have_http_status(:ok)
  
          # レスポンスの確認
          json_response = JSON.parse(response.body)
          expect(json_response["recommendations"].size).to eq(3)
          expect(json_response["recommendations"].first).to eq("ハワイ: 美しいビーチ")
        end
      end
  
      context "with invalid parameters" do
        let(:invalid_params) { { travel_search: { age: nil, number: nil, gender: nil, budget: nil } } }
  
        it "returns an error message" do
          post travel_searches_path, params: invalid_params, as: :json
  
          expect(response).to have_http_status(:unprocessable_entity)
  
          json_response = JSON.parse(response.body)
          expect(json_response["error"]).to eq("Please fill in all the required fields")
        end
      end
    end
end