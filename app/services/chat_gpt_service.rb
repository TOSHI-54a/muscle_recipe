require 'httparty'

class ChatGptService

    API_URL = "https://api.openai.com/v1/chat/completions"

    def initialize(api_key = ENV["CHATGPT_API_KEY"])
        @api_key = api_key
    end

    def fetch_recipe(prompt)
        response = HTTPary.post(
            API_URL,
            headers: request_headers,
            body: request_body(prompt).to_json
        )
        parse_response(response)
    end

    private

    def request_headers
        {
            "Authorization" => "Bearer #{@api_key}",
            "Content_Type" => "application/json"
        }
    end

    def request_body(prompt)
        {
            model: 'gpt-3.5-turbo',
            prompt: prompt,
            messages: [
                { role: 'system', content: 'You are a professional fitness food advisor.You come up with healthy and tasty recipes based on the requirements provided by the user.'},
                { role: 'user', content: generate_prompt(params) }
            ],
            max_tokens: 150,
            temperature: 0.3
        }.to_json
    end

    def parse_response(response)
        if response.success?
            JSON.parse(response.body)["choices"].first["text"].strip
        else
            raise "ChatGPT API Error: #{response.body}"
        end
    end

    def generate_prompt(request_payload)
        # 空欄チェック: すべての値が空の場合にデフォルトのリクエストを生成
        if request_payload[:body_info].values.all?(&:blank?) &&
           request_payload[:recipe_complexity].blank? &&
           request_payload[:ingredients][:use].blank? &&
           request_payload[:ingredients][:avoid].blank? &&
           request_payload[:preferences][:goal].blank? &&
           request_payload[:seasonings].blank?
      
          # デフォルトプロンプト
          return "ヘルシーで手軽な料理を提案してください。"
        end
      
        # 条件が入力されている場合のプロンプト生成
        <<~PROMPT
          以下の条件に合うレシピを提案してください：
          ・年齢：#{request_payload[:body_info][:age] || "指定なし"}歳
          ・性別：#{request_payload[:body_info][:gender] || "指定なし"}
          ・身長：#{request_payload[:body_info][:height] || "指定なし"}cm
          ・体重：#{request_payload[:body_info][:weight] || "指定なし"}kg
          ・料理の複雑度：#{request_payload[:recipe_complexity] || "指定なし"}
          ・使用したい具材：#{request_payload[:ingredients][:use]&.join(", ") || "指定なし"}
          ・避けたい具材：#{request_payload[:ingredients][:avoid]&.join(", ") || "指定なし"}
          ・要望：#{request_payload[:preferences][:goal] || "指定なし"}
          ・調味料の指定：#{request_payload[:seasonings] || "指定なし"}
        PROMPT
      end
