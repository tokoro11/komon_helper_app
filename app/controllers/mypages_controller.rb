class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    # 未読通知（多すぎると崩れるので上限）
    @unread_notifications = current_user.notifications.unread
                                        .order(created_at: :desc)
                                        .limit(5)

    # 自分の申請（一覧）
    base = MatchApplication
             .includes(match_listing: %i[gym owner])
             .where(applicant: current_user)
             .order(created_at: :desc)

    @pending_applications  = base.where(status: :pending)
    @approved_applications = base.where(status: :approved)
    @history_applications  = base.where(status: %i[rejected canceled])

    # ✅ 自分の募集一覧（マイページ統合の本体）
    now = Time.zone.now
    today = now.to_date
    now_time = now.strftime("%H:%M:%S")

    my_base = current_user.match_listings
                          .includes(:gym, :match, :match_applications)
                          .order(match_date: :desc, start_time: :desc)

    # 未来（= 申請受付中の可能性があるもの）と過去（履歴）に分ける
    @my_upcoming_listings = my_base
      .where("match_date > ? OR (match_date = ? AND end_time > ?)", today, today, now_time)

    @my_past_listings = my_base
      .where("match_date < ? OR (match_date = ? AND end_time <= ?)", today, today, now_time)
  end
end
