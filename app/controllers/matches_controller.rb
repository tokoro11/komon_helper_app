class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]

  # GET /matches
  def index
    @matches = Match.all
  end

  # GET /matches/1
  def show
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
    @match.gym_name = @match.gym&.name
  end

  # POST /matches
  def create
    @match = Match.new(match_params.except(:gym_name))

    gym = find_or_create_gym_from_name(match_params[:gym_name])
    @match.gym = gym

    # ★自分が作った募集には申請できない
    prevent_apply_to_own_listing!(@match)

    respond_to do |format|
      if gym.present? && @match.errors.blank? && @match.save
        format.html { redirect_to @match, notice: "Match was successfully created." }
        format.json { render :show, status: :created, location: @match }
      else
        @match.errors.add(:gym_name, "を入力してください") if gym.nil?
        @match.gym_name = match_params[:gym_name]
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1
  def update
    gym = find_or_create_gym_from_name(match_params[:gym_name])
    @match.gym = gym

    # ★自分が作った募集には申請できない
    prevent_apply_to_own_listing!(@match)

    respond_to do |format|
      if gym.present? && @match.errors.blank? && @match.update(match_params.except(:gym_name))
        format.html { redirect_to @match, notice: "試合を更新しました" }
        format.json { render :show, status: :ok, location: @match }
      else
        @match.errors.add(:gym_name, "を入力してください") if gym.nil?
        @match.gym_name = match_params[:gym_name]
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  def destroy
    @match.destroy!

    respond_to do |format|
      format.html { redirect_to matches_path, notice: "Match was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(
      :team_a_id, :team_b_id, :starts_at, :note,
      :gym_name, :match_listing_id
    )
  end

  def find_or_create_gym_from_name(name)
    n = name.to_s.strip
    return nil if n.blank?

    Gym.find_or_create_by!(name: n)
  end

  # ★ここが「自分の募集への申請禁止」
  def prevent_apply_to_own_listing!(match)
    return unless respond_to?(:current_user)
    return if current_user.nil?
    return if match.match_listing_id.blank?

    listing = MatchListing.find_by(id: match.match_listing_id)
    return if listing.nil?

    if listing.owner_id == current_user.id
      match.errors.add(:base, "自分が作った募集には申請できません")
    end
  end
end
