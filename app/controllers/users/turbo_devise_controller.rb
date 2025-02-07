class TurboDeviseController < Devise::SessionsController
    # Turbo互換性のためのDevise設定
    def respond_to_on_destroy
      respond_to do |format|
        format.all { head :no_content }
      end
    end
end
