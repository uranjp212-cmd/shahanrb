class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  helper_method :current_shain, :shain_logged_in?
  private

  def current_shain
    @current_shain ||= Ff2::Shain.find_by(SHAINCD: session[:shain_id]) if session[:shain_id]
  end

  def shain_logged_in?
    current_shain.present?
  end

  # ログイン必須の画面にかけるフィルター
  def require_shain_login
    unless shain_logged_in?
      redirect_to login_path, alert: "ログインが必要です。"
    end
  end
end
