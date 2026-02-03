class ApplicationController < ActionController::Base
  # ホーム(index)とDeviseとRails内部(health/pwa)以外はログイン必須
  before_action :authenticate_user!, unless: :public_access?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # ✅ Devise: サインアップ/更新で受け取る項目を許可
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :affiliation, :team_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role, :affiliation, :team_name])
  end

  # ✅ ログイン後の遷移（サインアップ後も最終的にはサインイン状態になるのでここで統一）
  def after_sign_in_path_for(resource)
    # チーム未設定ならプロフィールへ（保険：signupで必須にするなら基本通らない）
    return edit_profile_path if resource.team.nil?

    mypage_path
  end

  private

  # ✅ ログイン不要ページ
  def public_access?
    return true if devise_controller? # /users/sign_in /users/sign_up など
    return true if controller_name == "home" && action_name == "index" # /
    return true if controller_path.start_with?("rails/") # /up /manifest 等
    false
  end

  # ✅ チーム/所属が必要な機能の入口ガード（例：試合予定/募集のnew/createなど）
  def require_profile_ready!
    missing = []
    missing << "所属（例：〇〇高校）" if current_user&.affiliation.blank?
    missing << "チーム名（例：〇〇高校バレー部）" if current_user&.team.blank?

    return if missing.empty?

    redirect_to edit_profile_path, alert: "まずプロフィールの#{missing.join('・')}を設定してください"
  end
end
