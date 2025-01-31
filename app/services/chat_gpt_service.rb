require "httparty"
require "dotenv/load"

class ChatGptService
    API_URL = "https://api.openai.com/v1/chat/completions"

    def initialize(api_key = ENV["CHATGPT_API_KEY"])
        @api_key = api_key
    end

    def fetch_recipe(prompt)
        request = request_body(prompt)
        Rails.logger.debug "ChatGPT API Request Model: #{request[:model]}"
        Rails.logger.debug "ChatGPT API Request Body (Before JSON.dump): #{request.inspect}"
        Rails.logger.debug "ChatGPT API Request Body (After JSON.dump): #{JSON.dump(request)}"
        response = HTTParty.post(
            API_URL,
            headers: request_headers,
            body: JSON.dump(request)
        )
        parse_response(response)
    end

    private

    def request_headers
        {
            "Authorization" => "Bearer #{@api_key}",
            "Content-Type" => "application/json"
        }
    end

    def request_body(prompt)
        {
            model: "gpt-3.5-turbo",
            messages: [
                { role: "system", content: "You are a professional fitness food advisor.You come up with healthy and tasty recipes based on the requirements provided by the user." },
                { role: "user", content: generate_prompt(prompt) }
            ],
            max_tokens: 150,
            temperature: 0.3
        }.to_json
    end

    def parse_response(response)
        if response.success?
          parsed_data = JSON.parse(response.body)
      
          # 統一されたフォーマットのレスポンスを作成
          recipe_data = parsed_data["choices"].first["message"]["content"].strip
          format_recipe_response(recipe_data)
        else
          raise "ChatGPT API Error: #{response.body}"
        end
    end

    def format_recipe_response(recipe_text)
        recipe_lines = recipe_text.split("\n").reject(&:blank?)
        
        {
          title: recipe_lines[0],  # 最初の行をタイトルとする
          description: recipe_lines[1],  # 次の行を説明文
          ingredients: extract_ingredients(recipe_lines),  # 材料
          steps: extract_steps(recipe_lines)  # 作り方
        }
    end

    def extract_ingredients(lines)
        start_index = lines.index { |l| l.include?("材料") } || 0
        end_index = lines.index { |l| l.include?("作り方") } || lines.size
        
        lines[start_index + 1...end_index].map(&:strip)
    end

    def extract_steps(lines)
        start_index = lines.index { |l| l.include?("作り方") } || lines.size
        lines[start_index + 1..].map(&:strip)
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
          ・使用したい具材：#{Array(request_payload.dig(:ingredients, :use)).reject(&:blank?).join(", ") || "指定なし"}
          ・避けたい具材：#{Array(request_payload.dig(:ingredients, :avoid)).reject(&:blank?).join(", ") || "指定なし"}
          ・要望：#{request_payload[:preferences][:goal] || "指定なし"}
          ・調味料の指定：#{request_payload[:seasonings] || "指定なし"}
        PROMPT
    end
end
