require "httparty"
require "dotenv/load"

class ChatGptService
    API_URL = "https://api.openai.com/v1/chat/completions"

    def initialize(api_key = ENV["CHATGPT_API_KEY"])
        @api_key = api_key
    end

    def fetch_recipe(prompt)
        Rails.logger.debug "rrrr"
        request = request_body(prompt)
        Rails.logger.debug "ChatGPT API Request: #{request.to_json}"
        Rails.logger.debug "ChatGPT API Request Model: #{request[:model]}"
        response = HTTParty.post(
            API_URL,
            headers: request_headers,
            body: request.to_json
        )
        Rails.logger.debug "れっすぽんす #{response.inspect}"
        parse_response(response)
    rescue StandardError => e
        Rails.logger.error "Error in fetch_recipe: #{e.message}"
        nil
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
            max_tokens: 300,
            temperature: 0.3
        }
    end

    def parse_response(response)
        Rails.logger.debug "YYY:#{response.inspect}"
        if response.success?
          parsed_data = JSON.parse(response.body)
          Rails.logger.debug "パーシで:#{parsed_data.inspect}"

          # 統一されたフォーマットのレスポンスを作成
          recipe_text = parsed_data.dig("choices", 0, "message", "content")&.strip
          raise "Empty recipe response" if recipe_text.nil? || recipe_text.empty?
          Rails.logger.debug "rerere:#{recipe_text}"
          format_recipe_response(recipe_text)
        else
          raise "ChatGPT API Error: #{response.body}"
        end
    end

    def format_recipe_response(recipe_data)
        recipe_lines = recipe_data.split("\n").reject(&:blank?)
        return nil if recipe_lines.empty?

        {
          recipe: {
            title: recipe_lines[0], # 最初の行をタイトルとする
            description: recipe_lines[1] || "", # 次の行を説明文
            ingredients: extract_ingredients(recipe_lines), # 材料（そのままの形式で保存）
            steps: extract_steps(recipe_lines), # 作り方
            nutrition: extract_nutrition(recipe_lines) # 栄養情報
          }
        }
    end

    def extract_ingredients(recipe_lines)
        start_index = recipe_lines.index { |l| l.include?("材料") } || 0
        end_index = recipe_lines.index { |l| l.include?("作り方") } || recipe_lines.size

        ingredients = recipe_lines[start_index + 1...end_index]
        return [] if ingredients.nil?

        ingredients.map(&:strip) # 数値や単位の分離は行わない
    end

    def extract_steps(recipe_lines)
        start_index = recipe_lines.index { |l| l.include?("作り方") } || recipe_lines.size
        steps = recipe_lines[start_index + 1..]

        return [] if steps.nil?
        steps.map(&:strip)
    end

    def extract_nutrition(recipe_lines)
        nutrition_info = {
            calories: nil,
            protein: nil,
            fat: nil,
            carbohydrates: nil
        }
        recipe_lines.each do |line|
            if line.include?("カロリー")
                nutrition_info[:calories] = line.match(/\d+cal/).to_s.to_i
            elsif line.include?("タンパク質")
                nutrition_info[:protein] = line.match(/\d+g/).to_s
            elsif line.include?("脂質")
                nutrition_info[:fat] = line.match(/\d+g/).to_s
            elsif line.include?("炭水化物")
                nutrition_info[:carbohydrates] = line.match(/\d+g/).to_s
            end
        end

        nutrition_info
    end

    def generate_prompt(request_payload)
        Rails.logger.debug "リクエストペイ #{request_payload.inspect}"

        body_info = request_payload[:body_info] || {}
        ingredients = request_payload[:ingredients] || {}
        preferences = request_payload[:preferences] || {}

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
          なお、一行目は料理名、二行目は料理の簡単な説明としてください。
        PROMPT
    end
end
