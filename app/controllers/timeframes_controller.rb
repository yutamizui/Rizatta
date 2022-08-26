class TimeframesController < ApplicationController
  before_action :find_timeframe, only: [:edit, :update, :destroy]
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
    @timeframes = Timeframe.where(branch_id: params[:branch_id]).order(target_date: :asc)
    @rooms = Room.where(branch_id: params[:branch_id])
    @room = Room.find_by(name: params[:room])
    @reservation = Reservation.new
  end

  def new
    @timeframe = Timeframe.new
    @rooms = Room.where(branch_id: params[:branch_id])
    @page_type = "new"
    @branch = Branch.find(params[:branch_id])
    @target_timeframes = @branch.timeframes
  end

  def create
    @timeframe = Timeframe.new(timeframe_params)
    @timeframe.color = params[:timeframe][:color].to_i
    if @timeframe.save
      redirect_to timeframes_path(branch_id: @timeframe.branch_id), notice: t('activerecord.attributes.link.created')
    else
      flash.now[:alert] = t('activerecord.attributes.link.failed_to_create')
      render 'timeframes/new'
    end
  end

  def edit
    @rooms = Room.where(id: current_company.branches.pluck(:id))
    @page_type = "edit"
  end

  def update
    if @timeframe.update(timeframe_params)
      redirect_to timeframes_path(branch_id: @timeframe.branch_id), notice: t('activerecord.attributes.link.updated')
    else
      flash[:notice] = t('activerecord.attributes.link.failed_to_create')
      render 'timeframess/edit'
    end
  end

  def destroy
    @branch_id = @timeframe.branch_id
    if @timeframe.destroy
      redirect_to timeframes_path(branch_id: @branch_id), notice: t('activerecord.attributes.link.deleted')
    end
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
    this_monday = @start_day.beginning_of_week
    @days = (0..6).map {|i| this_monday.since(i.days)}
  end

  def set_day
    if params[:day].present?
      @day = Date.parse(params[:day])
    else
      @day = Date.today
    end
  end

  def find_timeframe
    @timeframe = Timeframe.find(params[:id])
  end

  def timeframe_params
    params.require(:timeframe).permit(:name, :target_date, :start_time, :end_time, :capacity, :color, :branch_id, :room_id)
  end
end
