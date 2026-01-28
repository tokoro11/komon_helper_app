class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read!
  end
end
