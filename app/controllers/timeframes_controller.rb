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
    target_date = params[:timeframe][:target_date]
    start_hour = params[:timeframe]["start_time(4i)"].to_s
    start_min = params[:timeframe]["start_time(5i)"].to_s
    @timeframe.target_date = target_date + " " + start_hour + ":" + start_min
    if current_staff.present? 
      @timeframe.staff_id = current_staff.id
    end
    @timeframe.color = params[:timeframe][:color].to_i

    unless Timeframe.timeframe_duplicate?(@timeframe)
      @timeframe.save

      redirect_to reservations_path(branch_id: @timeframe.branch_id, week: @week), notice: t('activerecord.attributes.link.created')
    else
      flash.now[:alert] = t('activerecord.attributes.link.failed_to_create')
      render 'timeframes/new'
    end
  end

  def single_duplicate
    @timeframe = Timeframe.find(params[:timeframe_id])
    @number_of_week = params[:how_many_week].to_i
    timeframe_duplicate_count = 0
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
            staff_id: @timeframe.staff_id
          )
          unless Timeframe.timeframe_duplicate?(timeframe)
            timeframe.save!
          else
            timeframe_duplicate_count += 1
          end
        end
      end
    rescue => e
      err_info = {alert: 'エラーがおこりました'}
      logger.error e.message
    end
    if I18n.locale == :ja
      redirect_to reservations_path(branch_id: @timeframe.branch_id), notice: "#{@number_of_week}" + t('activerecord.attributes.timeframe.created_weekly')
    else
      redirect_to reservations_path(branch_id: @timeframe.branch_id), notice: t('activerecord.attributes.timeframe.created_weekly') + " #{@number_of_week}" + "weeks"
    end
  end

  def multiple_duplicate
    @timeframe = Timeframe.find(params[:timeframe_id])
    @timeframes = Timeframe.where("target_date >= ?", @timeframe.target_date.beginning_of_day).where("target_date <= ?", @timeframe.target_date.end_of_day).where(branch_id: @timeframe.branch_id)
    
    @number_of_week = params[:how_many_week].to_i
    timeframe_duplicate_count = 0
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
              staff_id: t.staff_id
            )
            unless Timeframe.timeframe_duplicate?(timeframe)
              timeframe.save!
            else
              timeframe_duplicate_count += 1
            end
          end
        end
      end
    rescue => e
      err_info = {alert: 'エラーがおこりました'}
      logger.error e.message
    end
    if I18n.locale == :ja
      redirect_to reservations_path(branch_id: @timeframe.branch_id), notice: "#{@number_of_week}" + t('activerecord.attributes.timeframe.created_weekly')
    else
      redirect_to reservations_path(branch_id: @timeframe.branch_id), notice: t('activerecord.attributes.timeframe.created_weekly') + " #{@number_of_week}" + "weeks"
    end
  end

  def time_based_multiple_duplicate
    @timeframe = Timeframe.find(params[:timeframe_id])
    @displayed_timeframes = Timeframe.where("target_date >= ?", Date.today.beginning_of_day).where("target_date <= ?", Date.today.end_of_day.since(6.days)).where(branch_id: @timeframe.branch_id)
    target_hour = @timeframe.start_time.strftime("%H:00").to_i
    target_week = @timeframe.target_date.strftime("%w").to_i
    selected_day = params[:target_day].map(&:to_i)
    

    target_timeframes = []
    @displayed_timeframes.each do |dt|
      if dt.start_time.strftime("%H:%M").to_i >= target_hour && dt.start_time.strftime("%H:%M").to_i < target_hour + 1 && selected_day.include?(dt.target_date.strftime("%w").to_i)
        target_timeframes << dt
      end
    end
    @target_timeframes = target_timeframes
    @number_of_week = params[:how_many_week].to_i
    timeframe_duplicate_count = 0
    begin
      Timeframe.transaction do
        for num in (1..@number_of_week) do
          @target_timeframes.each do |t|
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
              staff_id: t.staff_id
            )
            unless Timeframe.timeframe_duplicate?(timeframe)
              timeframe.save!
            else
              timeframe_duplicate_count += 1
            end
          end
        end
      end
    rescue => e
      err_info = {alert: 'エラーがおこりました'}
      logger.error e.message
    end
    if I18n.locale == :ja
      redirect_to reservations_path(branch_id: @timeframe.branch_id), notice: "#{@number_of_week}" + t('activerecord.attributes.timeframe.created_weekly')
    else
      redirect_to reservations_path(branch_id: @timeframe.branch_id), notice: t('activerecord.attributes.timeframe.created_weekly') + " #{@number_of_week}" + "weeks"
    end
  end



  def edit
    @rooms = Room.where(id: company_admin.branches.pluck(:id))
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
    @week = params[:week]
    @branch_id = @timeframe.branch_id
    if @timeframe.destroy
      redirect_to reservations_path(branch_id: @branch_id, style: params[:style], week: @week  ), notice: t('activerecord.attributes.link.deleted')
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
