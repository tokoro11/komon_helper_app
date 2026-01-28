class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def show
    notification = current_user.notifications.find(params[:id])
    notification.mark_as_read!

    # 通知の紐づき先へ飛ばす（なければ一覧へ）
    notifiable = notification.notifiable

    if notifiable.is_a?(MatchApplication)
      redirect_to match_listing_match_applications_path(notifiable.match_listing)
    elsif notifiable.is_a?(MatchListing)
      redirect_to match_listing_path(notifiable)
    elsif notifiable.is_a?(Match)
      redirect_to match_path(notifiable)
    else
      redirect_to notifications_path
    end
  end
end
