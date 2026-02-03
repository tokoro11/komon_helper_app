class Users::SessionsController < Devise::SessionsController
  GUEST_EMAIL = "komon@example.com".freeze
  # ↑ seed で作ったデモ用アカウントと必ず一致させる

  def guest_sign_in
    user = User.find_by(email: GUEST_EMAIL)

    unless user
      redirect_to new_user_session_path,
                  alert: "ゲストアカウントが見つかりません。"
      return
    end

    # 念のため必須項目を補完（既に入っていれば何もしない）
    user.update!(
      name:        "ゲストユーザー",
      affiliation: "ゲスト（デモ）"
    ) if user.name.blank? || user.affiliation.blank?

    sign_in(:user, user)
    redirect_to mypage_path, notice: "ゲストとしてログインしました。"
  end
end
