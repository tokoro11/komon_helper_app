class MatchListingsController < ApplicationController
  before_action :set_match_listing, only: %i[show]

  def index
    @match_listings = MatchListing.open.order(match_date: :asc, start_time: :asc)
  end

  def show
  end

  def new
    @match_listing = MatchListing.new
  end

  def create
    @match_listing = MatchListing.new(match_listing_params)
    @match_listing.owner = User.first
    @match_listing.status = :open

    if @match_listing.save
      redirect_to @match_listing, notice: "募集を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_match_listing
    @match_listing = MatchListing.find(params[:id])
  end

  def match_listing_params
    params.require(:match_listing).permit(
      :gym_id, :match_date, :start_time, :end_time,
      :gender_category, :school_category, :notes
    )
  end
end
