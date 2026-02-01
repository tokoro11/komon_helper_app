class MatchListingsController < ApplicationController
  before_action :set_match_listing, only: %i[show edit update destroy]
  before_action :authorize_owner!, only: %i[edit update destroy]

  before_action :authenticate_user!
  before_action :require_affiliation!, only: %i[new create edit update]

  def index
    now = Time.zone.now
    today = now.to_date
    now_time = now.strftime("%H:%M:%S")

    base = MatchListing.where(status: :open)
                       .where("match_date > ? OR (match_date = ? AND end_time > ?)", today, today, now_time)
                       .includes(:gym, :owner)
                       .references(:gym)

    @q = base.ransack(params[:q])
    @q.sorts = ["match_date asc", "start_time asc"] if @q.sorts.empty?
    @match_listings = @q.result(distinct: true).page(params[:page]).per(20)
  end

  def show
    @my_application =
      current_user && @match_listing.match_applications.find_by(applicant_id: current_user.id)
  end

  def new
    @match_listing = MatchListing.new
  end

  def create
    @match_listing = MatchListing.new(match_listing_params.except(:gym_name, :gym_address))
    @match_listing.owner = current_user

    gym = find_or_create_gym_from_name_and_address(
      match_listing_params[:gym_name],
      match_listing_params[:gym_address]
    )
    @match_listing.gym = gym

    if gym.present? && @match_listing.save
      redirect_to @match_listing, notice: "募集を作成しました"
    else
      attach_gym_errors_if_needed(gym)
      restore_gym_virtual_fields
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @match_listing.gym_name = @match_listing.gym&.name
    @match_listing.gym_address = @match_listing.gym&.address
  end

  def update
    gym = find_or_create_gym_from_name_and_address(
      match_listing_params[:gym_name],
      match_listing_params[:gym_address]
    )
    @match_listing.gym = gym

    if gym.present? && @match_listing.update(match_listing_params.except(:gym_name, :gym_address))
      redirect_to @match_listing, notice: "募集を更新しました"
    else
      attach_gym_errors_if_needed(gym)
      restore_gym_virtual_fields
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @match_listing.destroy
      redirect_to match_listings_path, notice: "募集を削除しました"
    else
      redirect_to match_listing_path(@match_listing),
                  alert: @match_listing.errors.full_messages.join(", ")
    end
  end

  private

  def set_match_listing
    @match_listing = MatchListing.find(params[:id])
  end

  def authorize_owner!
    return if @match_listing.owner == current_user
    redirect_to match_listings_path, alert: "権限がありません"
  end

  def match_listing_params
    params.require(:match_listing).permit(
      :match_date,
      :start_time,
      :end_time,
      :gender_category,
      :school_category,
      :status,
      :notes,
      :gym_name,
      :gym_address
    )
  end

  # ✅ Gym を作る/再利用する（失敗したら nil を返す）
  def find_or_create_gym_from_name_and_address(name, address)
    n = name.to_s.strip
    a = address.to_s.strip
    return nil if n.blank? || a.blank?

    gym = Gym.find_or_initialize_by(name: n)
    gym.address = a

    return gym if gym.save
    nil
  end

  # ✅ gym が nil のとき、入力不足や保存失敗のエラーを付与
  def attach_gym_errors_if_needed(gym)
    return if gym.present?

    if match_listing_params[:gym_name].to_s.strip.blank?
      @match_listing.errors.add(:gym_name, "を入力してください")
    end

    if match_listing_params[:gym_address].to_s.strip.blank?
      @match_listing.errors.add(:gym_address, "を入力してください")
    end

    # name/address は入ってるのに gym が作れなかった（validation等）
    if match_listing_params[:gym_name].to_s.strip.present? && match_listing_params[:gym_address].to_s.strip.present?
      @match_listing.errors.add(:base, "体育館の保存に失敗しました。入力内容を確認してください")
    end
  end

  # ✅ フォーム再表示時に仮想属性を戻す
  def restore_gym_virtual_fields
    @match_listing.gym_name = match_listing_params[:gym_name]
    @match_listing.gym_address = match_listing_params[:gym_address]
  end

  # ✅ affiliation 未設定ユーザーは募集作成/編集に進めない
  def require_affiliation!
    return if current_user&.affiliation.to_s.strip.present?
    redirect_to edit_user_registration_path, alert: "所属を設定してください"
  end
end
