class SalesItemsController < ApplicationController
  before_action :find_sales_item, only: [:show, :edit, :update, :delete]
  
  def index
    @branches = company_admin.branches
    @sales_items = SalesItem.where(branch_id: params[:branch_id])
  end


  def show
    @sales_item = SalesItem.find(params[:id])
  end

  def new
    @sales_item = SalesItem.new
    @sales_item.branch_id = params[:branch_id]
  end

  def create
    @sales_items = SalesItem.create(sales_item_params)

    redirect_to sales_items_path(branch_id: @sales_item.branch_id), notice: t('activerecord.attributes.link.created')
  end

  def edit
  end

  def update
    @sales_item.update(sales_item_params)
    if ticket.update(sales_item_params)
      redirect_to sales_items_path(id: @sales_item.id), notice: t('activerecord.attributes.link.edited')
    else
      flash[:notice] = t('activerecord.attributes.link.failed_to_create')
      render 'tickets/edit'
    end
  end

  def destroy
    @sales_item.destroy
    redirect_to sales_items_path(id: @sales_item.id), notice: t('activerecord.attributes.link.deleted')
  end

  private
    def find_sales_item
      @sales_item = SalesItem.find(params[:id])
    end

    def sales_item_params
      params.require(:sales_item).permit(:user_id, :reservation_id, :expired_at, :status)
    end
end