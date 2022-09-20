class TicketsController < ApplicationController
  before_action :find_ticket, only: [:show, :edit, :update, :delete]

  def show
    @ticket = Ticket.find(params[:id])
  end

  def new
    @ticket = Ticket.new
    @ticket.branch_id = params[:branch_id]
  end

  def create
    params[:number_of_ticket].to_i.times do
      @ticket = Ticket.create(
        expired_at: params[:expired_at].in_time_zone.end_of_day,
        user_id: params[:user_id],
        status: "true",
      )
      
    end
    redirect_to users_path(branch_id: @ticket.user.branch_id), notice: t('activerecord.attributes.link.created')
  end

  def edit
  end

  def update
    @ticket.update(ticket_params)
    if ticket.update(ticket_params)
      redirect_to ticket_path(id: @ticket.id), notice: t('activerecord.attributes.link.edited')
    else
      flash[:notice] = t('activerecord.attributes.link.failed_to_create')
      render 'tickets/edit'
    end
  end

  def destroy
  end

  private
    def find_ticket
      @ticket = Ticket.find(params[:id])
    end

    # def ticket_params
    #   params.require(:ticket).permit(:user_id, :reservation_id, :expired_at, :status)
    # end
end
