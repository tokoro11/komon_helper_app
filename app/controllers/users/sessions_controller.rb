class Users::SessionsController < Devise::SessionsController
  GUEST_EMAIL = "tokohirohiroto@gmal.com".freeze

  def guest_sign_in
    user = User.find_by!(email: GUEST_EMAIL)

    # ゲスト用に最低限を補完（万が一 nil でも落ちない）
    user.update!(name: "ゲスト") if user.name.blank?
    user.update!(affiliation: "ゲストチーム") if user.affiliation.blank?

    sign_in user
    redirect_to mypage_path, notice: "ゲストとしてログインしました。"
  end
end
