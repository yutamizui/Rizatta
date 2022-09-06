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

  def single_duplicate
    @timeframe = Timeframe.find(params[:timeframe_id])
    @number_of_week = params[:how_many_week].to_i

    begin
      Timeframe.transaction do
        for num in (1..@number_of_week) do
          timeframe = Timeframe.new(
            name: @timeframe.name,
            target_date: @timeframe.target_date.since(num.week),
            start_time: @timeframe.start_time,
            end_time: @timeframe.end_time,
            capacity: @timeframe.capacity,
            color: @timeframe.color,
            branch_id: @timeframe.branch_id,
            room_id: @timeframe.room_id,
            required_ticket_number: @timeframe.required_ticket_number,
          )
          
          unless Timeframe.timeframe_duplicate?(timeframe)
            timeframe.save!
          end
        end
      end
    rescue => e
      err_info = {alert: 'エラーがおこりました'}
      logger.error e.message
    end
    redirect_to reservations_path(branch_id: @timeframe.branch_id), notice: t('activerecord.attributes.link.created')
  end

  def multiple_duplicate
    @timeframe = Timeframe.find(params[:timeframe_id])
    @timeframes = Timeframe.where(target_date: @timeframe.target_date).where(branch_id: @timeframe.branch_id)
    @number_of_week = params[:how_many_week].to_i
    begin
      Timeframe.transaction do
        for num in (1..@number_of_week) do
          @timeframes.each do |t|
            timeframe = Timeframe.new(
              name: t.name,
              target_date: t.target_date.since(num.week),
              start_time: t.start_time,
              end_time: t.end_time,
              capacity: t.capacity,
              color: t.color,
              branch_id: t.branch_id,
              room_id: t.room_id,
              required_ticket_number: t.required_ticket_number,
            )
            unless Timeframe.timeframe_duplicate?(timeframe)
              timeframe.save!
            end
          end
        end
      end
    rescue => e
      err_info = {alert: 'エラーがおこりました'}
      logger.error e.message
    end
    redirect_to reservations_path(branch_id: @timeframe.branch_id), notice: t('activerecord.attributes.link.created')
  end

  def edit
    @rooms = Room.where(id: current_company.branches.pluck(:id))
    @page_type = "edit"
  end

  def update
    if @timeframe.update(timeframe_params)
      redirect_to reservations_path(branch_id: @timeframe.branch_id), notice: t('activerecord.attributes.link.updated')
    else
      flash[:notice] = t('activerecord.attributes.link.failed_to_create')
      render 'timeframess/edit'
    end
  end

  def destroy
    @branch_id = @timeframe.branch_id
    if @timeframe.destroy
      redirect_to reservations_path(branch_id: @branch_id, style: params[:style] ), notice: t('activerecord.attributes.link.deleted')
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
