class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.all
  end

  def new
    @reservation = Reservation.new
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

  def delete
  end

  private
    def reservation_params
      params.require(:reservation).permit(:user_id, :timeframe_id)
    end
end

