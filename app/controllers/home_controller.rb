class HomeController < ApplicationController
  def index
    @pending_listings =
      MatchListing
        .joins(:match_applications)
        .where(owner_id: current_user.id)
        .merge(MatchApplication.pending)
        .distinct
        .order(match_date: :asc, start_time: :asc)

    @pending_applications_count =
      MatchApplication
        .joins(:match_listing)
        .where(match_listings: { owner_id: current_user.id })
        .pending
        .count
  end
end
