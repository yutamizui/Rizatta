class ReservationsController < ApplicationController
  before_action :set_week
  before_action :set_this_week
  before_action :set_day

  def index
    if current_company.present?
      @branches = current_company.branches
      @branch = Branch.find(params[:branch_id])
    elsif current_staff.present?
      @branch = current_staff.branch
    else
      @branch = current_user.branch
    end
    @timeframes = Timeframe.where(branch_id: @branch.id).order(target_date: :asc)
    @rooms = Room.where(branch_id: @branch.id)
    @room = Room.find_by(name: params[:room])
    @reservation = Reservation.new
  end

  def list
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

  def new
    @reservation = Reservation.new
    @timeframe = Timeframe.find(params[:timeframe_id])
    @branch = Branch.find(@timeframe.branch_id)
    @available_tickets = current_user.tickets.where("expired_at > ?", Date.today.end_of_day).where(status: true)
  end

  def create
    @timeframe = Timeframe.find(params[:timeframe_id])
    @available_tickets = current_user.tickets.where("expired_at > ?", Date.today.end_of_day).where(status: true)
    if @available_tickets.present?
      
      @reservation = Reservation.create(
        user_id: params[:user_id].to_i,
        timeframe_id: params[:timeframe_id].to_i
      )
      @available_tickets.first.update(
        status: false,
        reservation_id: @reservation.id
      )
      redirect_to reservations_path(), notice: t('activerecord.attributes.link.created')
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @ticket = Ticket.where(reservation_id: @reservation.id)
    @ticket.update(
      status: true,
      reservation_id: nil
    )
    @reservation.destroy
    redirect_to reservations_path(), notice: t('activerecord.attributes.link.canceled')
  end

  private

  def set_week
    @week = params[:week].to_i.abs
    if @week == 0
      @start_day = Date.today
    else
      @start_day = Date.today.since(@week.weeks)
    end
  end

  def set_this_week
    @days = (0..6).map {|i| @start_day.since(i.days)}
  end

  def set_day
    if params[:day].present?
      @day = Date.parse(params[:day])
    else
      @day = Date.today
    end
  end

  def reservation_params
    params.require(:reservation).permit(:user_id, :timeframe_id)
  end
end

