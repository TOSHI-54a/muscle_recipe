class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, raise: false

    def google_oauth2
        binding.pry
        Rails.logger.debug "OmniAuth Params: #{request.env['omniauth.params'].inspect}"
        Rails.logger.debug "CSRF Token : #{params[:g_csrf_token]}"
        Rails.logger.debug "CSRF Token from params: #{params[:g_csrf_token]}"
        Rails.logger.debug "CSRF Token from cookies: #{cookies['g_csrf_token']}"
        # 手動でstateを確認
        if session[:omniauth_state] != params[:state]
            Rails.logger.debug "セッション: #{session[:omniauth_state]}"
            Rails.logger.debug "パラむず: #{params[:state]}"
            Rails.logger.debug "ダメでした"
            redirect_to root_path, alert: "CSRF検証に失敗しました。"
            return
        end
        binding.pry
        callback_for(:google)
    end

    def callback_for(provider)
        @user = User.from_omniauth(request.env["omniauth.auth"])

        if @user.persisted?
            sign_in_and_redirect @user, event: :authentication
            set_flash_message(:notice, :success, kind: provider.to_s.capitalize) if is_navigational_format?
        else
            session["devise.#{ provider }_data"] = request.env["omniauth.auth"].except(:extra)
            redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
        end
    end

    def failure
        Rails.logger.debug "Session State: #{session[:omniauth_state]}"
        Rails.logger.debug "Request State: #{params[:state]}"
        Rails.logger.debug "OmniAuth Params: #{request.env['omniauth.params'].inspect}"
        Rails.logger.debug "CSRF Token : #{params[:g_csrf_token]}"
        Rails.logger.debug "CSRF Token from cookies: #{cookies['g_csrf_token']}"
        redirect_to root_path, alert: "Authentication faild, please try again."
    end

    def passthru
        Rails.logger.debug "Passthru method was called!"
        super
    end

    private

    def auth
        auth = request.env["omniauth.auth"]
    end

    def verify_g_csrf_token
        if cookies["g_csrf_token"].blank? || params[:g_csrf_token].blank? || cookies["g_csrf_token"] != params[:g_csrf_token]
            redirect_to root_path, notice: "不正なアクセスです"
        end
    end

    def debug
        binding.pry
    end
end
