class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_match, only: %i[show edit update destroy]
  before_action :set_teams, only: %i[new edit create update]

  def index
    if current_user.team_id.blank?
      @matches = Match.none
      flash.now[:alert] = "チームに所属していないため、試合予定を表示できません"
      return
    end

    tid = current_user.team_id

    @matches = Match
      .includes(:gym, :team_a, :team_b, :match_listing)
      .where("team_a_id = :tid OR team_b_id = :tid", tid: tid)
      .order(Arel.sql("starts_at IS NULL, starts_at ASC"))
  end

  def show
    authorize_match_team!
  end

  def new
    if current_user.team_id.blank?
      redirect_to mypage_path, alert: "チームに所属していないため、試合予定を作成できません"
      return
    end

    @match = Match.new
    # 自チームは固定（入力ミス防止）
    @match.team_a_id = current_user.team_id
  end

  def edit
    authorize_match_team!

    @match.gym_name = @match.gym&.name
  end

  def create
    if current_user.team_id.blank?
      redirect_to mypage_path, alert: "チームに所属していないため、試合予定を作成できません"
      return
    end

    @match = Match.new(match_params.except(:gym_name))

    # ✅ 自チームを固定（ここがチーム単位運用の肝）
    @match.team_a_id = current_user.team_id

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
    authorize_match_team!

    gym = find_or_create_gym_from_name(match_params[:gym_name], match: @match)
    if gym.nil?
      @match.gym_name = match_params[:gym_name]
      return render :edit, status: :unprocessable_entity
    end
    @match.gym = gym

    # ✅ 更新でも自チームは固定（勝手に他チームに変えられない）
    @match.team_a_id = current_user.team_id

    prevent_apply_to_own_listing!(@match)
    if @match.errors.any?
      @match.gym_name = match_params[:gym_name]
      return render :edit, status: :unprocessable_entity
    end

    if @match.update(match_params.except(:gym_name, :team_a_id))
      redirect_to @match, notice: "予定を更新しました"
    else
      @match.gym_name = match_params[:gym_name]
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_match_team!

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

  # ✅ チーム単位：自チームが関係ない試合は見れない/編集できない
  def authorize_match_team!
    return if current_user.team_id.present? &&
              ( @match.team_a_id == current_user.team_id || @match.team_b_id == current_user.team_id )

    redirect_to matches_path, alert: "権限がありません"
  end

  # B（自由入力 + 候補）なので name を受け取る
  # ※ team_a_id は controller で固定するので permit しないのが安全
  def match_params
    params.require(:match).permit(
      :team_b_id, # 対戦相手をプルダウンで選ぶなら必要（使ってないなら消してOK）
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
    return if current_user.nil?
    return if match.match_listing_id.blank?

    listing = MatchListing.find_by(id: match.match_listing_id)
    return if listing.nil?

    match.errors.add(:base, "自分が作った募集には申請できません") if listing.owner_id == current_user.id
  end
end
