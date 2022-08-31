class TimeframesController < ApplicationController
  before_action :find_timeframe, only: [:edit, :update, :destroy]
  
  def new
    @timeframe = Timeframe.new
    @rooms = Room.where(branch_id: params[:branch_id])
    @room = @rooms.first
    @page_type = "new"
    @branch = Branch.find(params[:branch_id])
    @target_timeframes = @branch.timeframes
  end

  def create
    @timeframe = Timeframe.new(timeframe_params)
    @timeframe.color = params[:timeframe][:color].to_i
    if @timeframe.save
      redirect_to reservations_path(branch_id: @timeframe.branch_id), notice: t('activerecord.attributes.link.created')
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
      redirect_to timeframes_path(branch_id: @branch_id, style: "list_view" ), notice: t('activerecord.attributes.link.deleted')
    end
  end
  
  private

  def find_timeframe
    @timeframe = Timeframe.find(params[:id])
  end

  def timeframe_params
    params.require(:timeframe).permit(
      :name, :target_date, :start_time, :end_time, :capacity, :color, :branch_id, :room_id, :required_ticket_number
    )
  end
end
