class ReservationsController < ApplicationController
  def index
    if current_company.present?
      if params[:branch_id].present?
        @branch = Branch.find(params[:branch_id])
      else
        @branch = current_company.branches.first
      end
      if current_company.branches.count > 1
        @branches = current_company.branches
      end
      @reservations = Reservation.includes(:timeframe).where(timeframes: {branch_id: @branch.id}).order("timeframes.target_date ASC").order("timeframes.start_time ASC")
    elsif current_staff.present?
      @reservations = Reservation.where(staff_id: current_staff.id)
    elsif current_user.present?
      @reservations = Reservation.includes(:timeframe).where(user_id: current_user.id).order("timeframes.target_date ASC").order("timeframes.start_time ASC")
    end
    
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      redirect_to reservations_path(), notice: t('activerecord.attributes.link.created')
    else
      flash.now[:alert] = t('activerecord.attributes.link.failed_to_create')
      render 'new'
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    if @reservation.destroy
      redirect_to reservations_path(), notice: t('activerecord.attributes.link.canceled')
    end
  end

  private
    def reservation_params
      params.require(:reservation).permit(:user_id, :timeframe_id)
    end
end

