class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]
  before_action :set_teams, only: %i[new edit create update]

  def index
    @matches = Match.all
  end

  def show
  end

  def new
    @match = Match.new
  end

  def edit
    @match.gym_name = @match.gym&.name
  end

  def create
    @match = Match.new(match_params.except(:gym_name))

    gym = find_or_create_gym_from_name(match_params[:gym_name], match: @match)
    if gym.nil?
      @match.gym_name = match_params[:gym_name]
      return render :new, status: :unprocessable_entity
    end
    @match.gym = gym

    prevent_apply_to_own_listing!(@match)
    if @match.errors.any?
      @match.gym_name = match_params[:gym_name]
      return render :new, status: :unprocessable_entity
    end

    if @match.save
      redirect_to @match, notice: "予定を作成しました"
    else
      @match.gym_name = match_params[:gym_name]
      render :new, status: :unprocessable_entity
    end
  end

  def update
    gym = find_or_create_gym_from_name(match_params[:gym_name], match: @match)
    if gym.nil?
      @match.gym_name = match_params[:gym_name]
      return render :edit, status: :unprocessable_entity
    end
    @match.gym = gym

    prevent_apply_to_own_listing!(@match)
    if @match.errors.any?
      @match.gym_name = match_params[:gym_name]
      return render :edit, status: :unprocessable_entity
    end

    if @match.update(match_params.except(:gym_name))
      redirect_to @match, notice: "予定を更新しました"
    else
      @match.gym_name = match_params[:gym_name]
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @match.destroy!
    redirect_to matches_path, notice: "削除しました", status: :see_other
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def set_teams
    @teams = Team.order(:id)
  end

  # B（自由入力 + 候補）なので name を受け取る
  def match_params
    params.require(:match).permit(
      :team_a_name, :team_b_name, :starts_at, :note,
      :gym_name, :match_listing_id
    )
  end

  # ★ここがポイント：Gymの保存失敗理由をMatch側に載せる
  def find_or_create_gym_from_name(name, match:)
    n = name.to_s.strip
    if n.blank?
      match.errors.add(:gym_name, "を入力してください")
      return nil
    end

    gym = Gym.find_or_initialize_by(name: n)

    # 既に保存済みならOK
    return gym if gym.persisted?

    # 新規保存（Gym側バリデーションで落ちる可能性あり）
    unless gym.save
      msg = gym.errors.full_messages.join(" / ")
      match.errors.add(:gym_name, "の登録に失敗しました: #{msg}")
      return nil
    end

    gym
  end

  def prevent_apply_to_own_listing!(match)
    return unless respond_to?(:current_user)
    return if current_user.nil?
    return if match.match_listing_id.blank?

    listing = MatchListing.find_by(id: match.match_listing_id)
    return if listing.nil?

    match.errors.add(:base, "自分が作った募集には申請できません") if listing.owner_id == current_user.id
  end
end
