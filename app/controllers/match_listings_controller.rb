class MatchListingsController < ApplicationController
  before_action :set_match_listing, only: %i[show edit update destroy]
  before_action :authorize_owner!, only: %i[edit update destroy]

  def index
    @q = MatchListing.includes(:gym).references(:gym).ransack(params[:q])
    @q.sorts = ["match_date asc", "start_time asc"] if @q.sorts.empty?
    @match_listings = @q.result(distinct: true).page(params[:page]).per(20)
  end

  def show
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
      if gym.nil?
        @match_listing.errors.add(:gym_name, "を入力してください") if match_listing_params[:gym_name].to_s.strip.blank?
        @match_listing.errors.add(:gym_address, "を入力してください") if match_listing_params[:gym_address].to_s.strip.blank?
      end
      @match_listing.gym_name = match_listing_params[:gym_name]
      @match_listing.gym_address = match_listing_params[:gym_address]
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
      if gym.nil?
        @match_listing.errors.add(:gym_name, "を入力してください") if match_listing_params[:gym_name].to_s.strip.blank?
        @match_listing.errors.add(:gym_address, "を入力してください") if match_listing_params[:gym_address].to_s.strip.blank?
      end
      @match_listing.gym_name = match_listing_params[:gym_name]
      @match_listing.gym_address = match_listing_params[:gym_address]
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

  def find_or_create_gym_from_name_and_address(name, address)
    n = name.to_s.strip
    a = address.to_s.strip

    # ★体育館名も住所も必須
    return nil if n.blank? || a.blank?

    gym = Gym.find_or_initialize_by(name: n)
    gym.address = a
    gym.save!
    gym
  end
end
