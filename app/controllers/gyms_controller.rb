class GymsController < ApplicationController
  def index
    @q = params[:q].to_s.strip

    @gyms =
      if @q.present?
        Gym.where(
          "name ILIKE :q OR area ILIKE :q OR address ILIKE :q",
          q: "%#{@q}%"
        ).order(:area, :name)
      else
        Gym.none
      end
  end

  def show
    @gym = Gym.find(params[:id])
  end
end
