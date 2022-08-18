class RoomsController < ApplicationController
  before_action :find_room, only: [:show, :edit, :update, :delete]

  def index
    @rooms = Room.where(branch_id: params[:branch_id])
    @branches = current_company.branches
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = Room.new
    @room.branch_id = params[:branch_id]
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to rooms_path(branch_id: @room.branch_id), notice: t('activerecord.attributes.link.created')
    else
      flash.now[:alert] = t('activerecord.attributes.link.failed_to_create')
      render 'new'
    end
  end

  def edit
  end

  def update
    @room.update(room_params)
    if room.update(room_params)
      redirect_to room_path(id: @room.id), notice: t('activerecord.attributes.link.edited')
    else
      flash[:notice] = t('activerecord.attributes.link.failed_to_create')
      render 'rooms/edit'
    end
  end

  def delete
  end

  private
    def find_room
      @room = Room.find(params[:id])
    end

    def room_params
      params.require(:room).permit(:name, :branch_id)
    end
end
