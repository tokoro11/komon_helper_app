class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :affiliation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role, :affiliation])
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_up_path_for(resource)
    root_path
  end

  private

  # ✅ 所属が未設定ならプロフィール編集へ誘導
  def require_affiliation!
    return if current_user&.affiliation.present?

    redirect_to edit_profile_path, alert: "まずプロフィールの所属（例：〇〇高校バレー部）を設定してください"
  end
end
