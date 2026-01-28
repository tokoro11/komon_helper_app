class ApplicationController < ActionController::Base
  # Deviseのログイン/新規登録画面はログイン不要なので除外
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :affiliation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role, :affiliation])
  end

  def after_sign_in_path_for(_resource)
    root_path
  end

  def after_sign_up_path_for(_resource)
    root_path
  end

  private

  # ✅ 所属が未設定ならプロフィール編集へ誘導（使うコントローラで before_action する）
  def require_affiliation!
    return if current_user&.affiliation.present?

    redirect_to edit_profile_path, alert: "まずプロフィールの所属（例：〇〇高校バレー部）を設定してください"
  end
end
