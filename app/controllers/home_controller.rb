class HomeController < ApplicationController
  def index
    if user_signed_in?
      @pending_listings =
        MatchListing
          .joins(:match_applications)
          .where(owner_id: current_user.id)
          .merge(MatchApplication.pending)
          .distinct
          .order(match_date: :asc, start_time: :asc)
    else
      @pending_listings = MatchListing.none
    end
  end
end
