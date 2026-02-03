class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
    @user.team_name = @user.team&.name
  end

  def update
    @user = current_user

    team_name = profile_params[:team_name].to_s.strip
    if team_name.present?
      team = Team.find_or_create_by!(name: team_name)
      @user.team = team
    end

    # team_name はDBカラムじゃないので除外して update
    if @user.update(profile_params.except(:team_name))
      redirect_to mypage_path, notice: "プロフィールを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :affiliation, :team_name)
  end
end
