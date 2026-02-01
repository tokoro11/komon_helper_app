class ApplicationController < ActionController::Base
  # ✅ ホーム(index)とDeviseとRails内部(health/pwa)以外はログイン必須
  before_action :authenticate_user!, unless: :public_access?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :affiliation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role, :affiliation])
  end

  # ✅ ログイン後はマイページへ
  def after_sign_in_path_for(_resource)
    mypage_path
  end

  def after_sign_up_path_for(_resource)
    mypage_path
  end

  private

  # ✅ ここで「ログイン不要ページ」を定義
  def public_access?
    return true if devise_controller?                        # /users/sign_in など
    return true if controller_name == "home" && action_name == "index"  # /
    return true if controller_path.start_with?("rails/")     # /up や /manifest 等
    false
  end

  def require_affiliation!
    return if current_user&.affiliation.present?

    redirect_to edit_profile_path,
                alert: "まずプロフィールの所属（例：〇〇高校バレー部）を設定してください"
  end
end
