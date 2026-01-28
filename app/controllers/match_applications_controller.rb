class MatchApplicationsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_match_listing, if: -> { params[:match_listing_id].present? }
  before_action :set_match_application, only: [:show, :approve, :reject], if: -> { params[:match_listing_id].present? }
  before_action :authorize_owner!, only: [:index, :approve, :reject], if: -> { params[:match_listing_id].present? }

  def create
    return redirect_to match_listings_path, alert: "募集を選んでから申請してください" unless @match_listing.present?
    return redirect_to match_listing_path(@match_listing), alert: "この募集は受付終了です" unless @match_listing.open?

    if @match_listing.owner == current_user
      return redirect_to match_listing_path(@match_listing), alert: "自分が作った募集には申請できません"
    end

    if current_user.affiliation.blank?
      return redirect_to edit_profile_path, alert: "申請するにはプロフィールの所属（例：〇〇高校バレー部）を設定してください"
    end

    @application = @match_listing.match_applications.new(match_application_params)
    @application.applicant = current_user
    @application.status = :pending

    if @application.save
      begin
        Notification.create!(
          user: @match_listing.owner,
          kind: :match_application_received,
          title: "試合申請が届きました",
          body: "#{current_user.affiliation} から申請が届きました。",
          notifiable: @application
        )
      rescue => e
        Rails.logger.warn("[Notification] failed to create match_application_received: #{e.class} #{e.message}")
      end

      redirect_to match_listing_path(@match_listing), notice: "申請しました"
    else
      redirect_to match_listing_path(@match_listing), alert: @application.errors.full_messages.join(", ")
    end
  end

  def index
    if @match_listing.present?
      @pending_apps = @match_listing.match_applications.pending.includes(:applicant).order(created_at: :desc)
      @handled_apps = @match_listing.match_applications.where.not(status: :pending).includes(:applicant).order(created_at: :desc)
    else
      @pending_apps = MatchApplication
        .joins(:match_listing)
        .includes(:applicant, match_listing: [:gym, :owner])
        .where(match_listings: { owner_id: current_user.id })
        .where(status: :pending)
        .order(created_at: :desc)

      @handled_apps = MatchApplication
        .joins(:match_listing)
        .includes(:applicant, match_listing: [:gym, :owner])
        .where(match_listings: { owner_id: current_user.id })
        .where.not(status: :pending)
        .order(created_at: :desc)
    end
  end

  def show
    @match_application = @match_listing.match_applications.find(params[:id])
  end

  def approve
    return redirect_to match_listing_match_applications_path(@match_listing), alert: "この申請は処理済みです" unless @match_application.pending?
    return redirect_to match_listing_match_applications_path(@match_listing), alert: "募集が受付中ではありません" unless @match_listing.open?

    owner = @match_listing.owner
    applicant = @match_application.applicant

    # ✅ team単位運用：両者が team に所属してないと成立させない
    if owner.team_id.blank? || applicant.team_id.blank?
      return redirect_to match_listing_match_applications_path(@match_listing),
                         alert: "チーム未所属のため承認できません（募集者・申請者ともにチーム所属が必要です）"
    end

    # 所属（表示用）が空ならメッセージは作れるが、あなたの運用ならここも必須のままでOK
    if owner.affiliation.blank? || applicant.affiliation.blank?
      return redirect_to match_listing_match_applications_path(@match_listing), alert: "所属が未設定のため承認できません"
    end

    if @match_listing.match.present?
      return redirect_to match_listing_match_applications_path(@match_listing), alert: "この募集はすでに試合が作成されています"
    end

    match = nil

    ActiveRecord::Base.transaction do
      @match_application.approved!
      @match_listing.closed!

      @match_listing.match_applications.pending.where.not(id: @match_application.id)
                    .update_all(status: MatchApplication.statuses[:rejected], updated_at: Time.current)

      starts_at = Time.zone.local(
        @match_listing.match_date.year,
        @match_listing.match_date.month,
        @match_listing.match_date.day,
        @match_listing.start_time.hour,
        @match_listing.start_time.min,
        @match_listing.start_time.sec
      )

      match = Match.create!(
        match_listing: @match_listing,
        gym_id: @match_listing.gym_id,
        starts_at: starts_at,

        # ✅ ここが本丸：IDを入れる
        team_a_id: owner.team_id,
        team_b_id: applicant.team_id,

        # ✅ 表示用の保険（既存データ互換・一覧/詳細で困らない）
        team_a_name: owner.team&.name.presence || owner.affiliation,
        team_b_name: applicant.team&.name.presence || applicant.affiliation,

        note: [
          @match_listing.notes.presence && "募集: #{@match_listing.notes}",
          @match_application.message.presence && "申請: #{@match_application.message}",
          "募集者所属: #{owner.affiliation}",
          "申請者所属: #{applicant.affiliation}"
        ].compact.join("\n")
      )

      Notification.create!(
        user: applicant,
        kind: :match_request_approved,
        title: "試合申請が承認されました",
        body: "#{owner.affiliation} が申請を承認しました。",
        notifiable: @match_application
      )
    end

    redirect_to match_path(match), notice: "承認して試合を作成しました"
  rescue ActiveRecord::RecordNotUnique
    redirect_to match_listing_match_applications_path(@match_listing), alert: "この募集はすでに試合が作成されています"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to match_listing_match_applications_path(@match_listing), alert: "失敗しました: #{e.record.errors.full_messages.join(', ')}"
  end

  def reject
    return redirect_to match_listing_match_applications_path(@match_listing), alert: "この申請は処理済みです" unless @match_application.pending?

    @match_application.rejected!

    Notification.create!(
      user: @match_application.applicant,
      kind: :match_request_rejected,
      title: "試合申請が却下されました",
      body: "#{@match_listing.owner.affiliation} が申請を却下しました。",
      notifiable: @match_application
    )

    redirect_to match_listing_match_applications_path(@match_listing), notice: "却下しました"
  end

  private

  def set_match_listing
    @match_listing = MatchListing.find(params[:match_listing_id])
  end

  def set_match_application
    @match_application = @match_listing.match_applications.find(params[:id])
  end

  def authorize_owner!
    unless @match_listing.owner == current_user
      redirect_to match_listing_path(@match_listing), alert: "権限がありません"
    end
  end

  def match_application_params
    params.require(:match_application).permit(:message)
  end
end
