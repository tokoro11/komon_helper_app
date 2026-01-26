class MatchApplicationsController < ApplicationController
  before_action :set_match_listing
  before_action :set_match_application, only: [:approve, :reject]
  before_action :authorize_owner!, only: [:index, :approve, :reject]

  def create
    return redirect_to match_listing_path(@match_listing), alert: "この募集は受付終了です" unless @match_listing.open?

    # ★追加：自分が作った募集には申請できない
    if @match_listing.owner == current_user
      return redirect_to match_listing_path(@match_listing), alert: "自分が作った募集には申請できません"
    end

    @application = @match_listing.match_applications.new(match_application_params)
    @application.applicant = current_user
    @application.status = :pending

    if @application.save
      redirect_to match_listing_path(@match_listing), notice: "申請しました"
    else
      redirect_to match_listing_path(@match_listing), alert: @application.errors.full_messages.join(", ")
    end
  end

  def index
    @pending_apps = @match_listing.match_applications.pending.includes(:applicant).order(created_at: :desc)
    @handled_apps = @match_listing.match_applications.where.not(status: :pending).includes(:applicant).order(created_at: :desc)
  end

  def approve
    return redirect_to match_listing_match_applications_path(@match_listing), alert: "この申請は処理済みです" unless @match_application.pending?
    return redirect_to match_listing_match_applications_path(@match_listing), alert: "募集が受付中ではありません" unless @match_listing.open?

    if @match_listing.owner.team_id.blank? || @match_application.applicant.team_id.blank?
      return redirect_to match_listing_match_applications_path(@match_listing), alert: "チーム情報が未設定のため承認できません"
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

      starts_at = Time.zone.parse(
        "#{@match_listing.match_date} #{@match_listing.start_time.strftime('%H:%M:%S')}"
      )

      match = Match.create!(
        match_listing: @match_listing,
        gym_id: @match_listing.gym_id,
        starts_at: starts_at,
        team_a_id: @match_listing.owner.team_id,
        team_b_id: @match_application.applicant.team_id,
        note: [
          @match_listing.notes.presence && "募集: #{@match_listing.notes}",
          @match_application.message.presence && "申請: #{@match_application.message}"
        ].compact.join("\n")
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
