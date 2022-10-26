class ReservationsController < ApplicationController
  before_action :set_week
  before_action :set_this_week
  before_action :set_day
  before_action :authenticate_any!

  def index
    if current_company.present?
      @branches = current_company.branches
      if params[:branch_id].present?
        @branch = Branch.find(params[:branch_id])
      else
        @branch = current_company.branches.first
      end
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
    if company_admin.present?
      if params[:branch_id].present?
        @branch = Branch.find(params[:branch_id])
      else
        @branch = company_admin.branches.first
      end
      if company_admin.branches.count > 0
        @branches = company_admin.branches
      end
      @reservations = Reservation.includes(:timeframe).where(timeframes: {branch_id: @branch.id}).order("timeframes.target_date ASC").order("timeframes.start_time ASC")
      @future_timeframes = Timeframe.where(branch_id: params[:branch_id]).where("target_date >= ?", Time.zone.now).order(target_date: :ASC)
      @past_timeframes = Timeframe.where(branch_id: params[:branch_id]).where("target_date < ?", Time.zone.now).order(target_date: :ASC)
    elsif current_staff.present?
      @reservations = Reservation.includes(:timeframe).where(timeframes: {branch_id: current_staff.branch_id}).order("timeframes.target_date ASC").order("timeframes.start_time ASC")
      @future_timeframes = Timeframe.where(staff_id: current_staff.id).where("target_date >= ?", Time.zone.now).order(target_date: :ASC)
      @past_timeframes = Timeframe.where(staff_id: current_staff.id).where("target_date < ?", Time.zone.now).order(target_date: :ASC)
    elsif current_user.present?
      @reservations = Reservation.includes(:timeframe).where(user_id: current_user.id).order("timeframes.target_date ASC").order("timeframes.start_time ASC")
    end
  end

  def new
    @reservation = Reservation.new
    @timeframe = Timeframe.find(params[:timeframe_id])
    @branch = Branch.find(@timeframe.branch_id)
    @users = User.where(branch_id: @branch.id)
    if current_user.present?
      @available_tickets = current_user.tickets.where("expired_at >= ?", Date.today.end_of_day).where(status: true)
      if @available_tickets.present? && @available_tickets.count >= @timeframe.required_ticket_number || @timeframe.required_ticket_number == 0
        @availability = true
      else
        @availability = false
      end
    end
  end

  def create
    @reservation = Reservation.new
    @timeframe = Timeframe.find(params[:timeframe_id])
    @branch = Branch.find(@timeframe.branch_id)
    @users = User.where(branch_id: @branch.id)
    if current_user.present?
      target_user = current_user
    else
      target_user = User.find(params[:user_id])
    end
    @available_tickets = target_user.tickets.order(:expired_at).where("expired_at >= ?", Date.today.end_of_day).where(status: true)
    if @available_tickets.present? && @available_tickets.count >= @timeframe.required_ticket_number || @timeframe.required_ticket_number == 0
      @reservation = Reservation.create(
        user_id: params[:user_id].to_i,
        timeframe_id: params[:timeframe_id].to_i
      )
      if @timeframe.required_ticket_number > 0
        @available_tickets.first(@timeframe.required_ticket_number).each do |t|
          t.update(
            status: false,
            reservation_id: @reservation.id
          )
        end
      end
      StaffActionMailer.reservation_notifier(@reservation, @timeframe).deliver
      redirect_to list_reservations_path, notice: t('activerecord.attributes.reservation.reserved')
    elsif @timeframe.required_ticket_number == 0
      @reservation = Reservation.create(
        user_id: params[:user_id].to_i,
        timeframe_id: params[:timeframe_id].to_i
      )
      StaffActionMailer.reservation_notifier(@reservation, @timeframe).deliver
      redirect_to list_reservations_path, notice: t('activerecord.attributes.reservation.reserved')
    else
      flash.now[:alert] = t('activerecord.attributes.reservation.failed')
      render 'reservations/new'
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @timeframe = @reservation.timeframe
    @tickets = Ticket.where(reservation_id: @reservation.id)
    @tickets.each do |t|
      t.update(
        status: true,
        reservation_id: nil
      )
    end
    StaffActionMailer.reservation_cancel_notifier(@reservation, @timeframe).deliver
    @reservation.destroy
    redirect_to list_reservations_path(), notice: t('activerecord.attributes.link.canceled')
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

  def authenticate_any!
    if company_signed_in? || staff_signed_in? || user_signed_in?
      true
    else
      authenticate_user!
    end
  end

  def reservation_params
    params.require(:reservation).permit(:user_id, :timeframe_id)
  end
end

