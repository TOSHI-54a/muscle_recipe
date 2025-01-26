class SearchesController < ApplicationController
  before_action :check_search_limit, only: :create
  skip_before_action :authenticate_user!

  def new
    @search_recipes = SearchRecipe.new
  end

  def create
    prompt = recipe_params
    recipe_response = ChatGptService.new.fetch_recipe(prompt)
    SearchRecipe.create!(
      user: current_user,
      query: prompt,
      search_time: Time.current,
      response_data: recipe_response
    )
    render json: { recipe: recipe_respnose }, status: ok
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def check_search_limit
    if current_user
      search_count = SearchLog.where(user_id: current_user.id, search_time: Date.current.all_day).count
      max_limit = 3
    else
      search_count = SearchLog.where(ip_address: request.remote_ip, search_time: Date.current.all_day).count
      max_limit = 1
    end

    if search_count >= max_limit
      render json: { status: "error", message: "Search limit reached for today" }, status: 403
    end
  end

  def recipe_params
    params.require(:search).permit(
      body_info: [ :age, :gender, :height, :weight ],
      recipe_complexity: :string,
      ingredients: { use: [], avoid: [], available: [ :name, :amount ] },
      seasonings: :string,
      preferences: [ :goal, :calorie_and_pfc ]
    ).to_h
  end
end
