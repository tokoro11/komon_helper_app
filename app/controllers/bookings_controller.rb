class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show edit update destroy approve reject cancel]
  before_action :authorize_booking!, only: %i[show edit update destroy cancel]
  before_action :require_admin!, only: %i[approve reject]

  # GET /bookings
  def index
    @bookings =
      if current_user.admin?
        Booking.includes(:user, :gym).order(created_at: :desc)
      else
        current_user.bookings.includes(:gym).order(created_at: :desc)
      end
  end

  # GET /bookings/1
  def show
  end

  # GET /bookings/new
  def new
    @booking = current_user.bookings.build
    @booking.status = :pending
  end

  # GET /bookings/1/edit
  def edit
    # ここに来られるのは authorize_booking! を通った本人だけ
  end

  # POST /bookings
  def create
    @booking = current_user.bookings.build(booking_params)
    @booking.status = :pending

    if @booking.save
      redirect_to @booking, notice: "体育館使用を申請しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bookings/1
  def update
    # user_id / status は更新させない（booking_paramsに含めない）
    if @booking.update(booking_params)
      redirect_to @booking, notice: "予約内容を更新しました", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /bookings/1
  def destroy
    @booking.destroy!
    redirect_to bookings_path, notice: "予約を削除しました", status: :see_other
  end

  # PATCH /bookings/:id/approve
  def approve
    @booking.update!(status: :approved)
    redirect_to @booking, notice: "承認しました"
  end

  # PATCH /bookings/:id/reject
  def reject
    @booking.update!(status: :rejected)
    redirect_to @booking, notice: "却下しました"
  end

  # PATCH /bookings/:id/cancel
  def cancel
    # 本人だけキャンセル可（adminも可にしたいなら authorize_booking! を調整）
    @booking.update!(status: :canceled)
    redirect_to @booking, notice: "キャンセルしました"
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  # ✅ user_id と status は permit しない
  def booking_params
    params.require(:booking).permit(:gym_id, :start_time, :end_time, :note)
  end

  # ✅ 本人 or admin だけアクセスOK
  def authorize_booking!
    return if current_user.admin?
    return if @booking.user_id == current_user.id
    redirect_to bookings_path, alert: "権限がありません"
  end

  # ✅ 承認・却下は admin のみ
  def require_admin!
    return if current_user.admin?
    redirect_to bookings_path, alert: "権限がありません"
  end
end
