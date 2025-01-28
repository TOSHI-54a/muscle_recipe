class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :authenticate_user!
  allow_browser versions: :modern
    # Turbo互換性のためのDevise設定
  class TurboDeviseController < Devise::SessionsController
    def respond_to_on_destroy
      respond_to do |format|
        format.all { head :no_content }
      end
    end
  end
end
