class BranchesController < ApplicationController
  before_action :find_branch, only: [:show, :edit, :update, :destroy]

  def index
    @branches = company_admin.branches
    @branch = @branches.first
  end

  def show
    @staffs = @branch.staffs
    @users = @branch.users
  end

  def new
    @branch = Branch.new
  end

  def create
    @branch = Branch.new(branch_params)
    @branch.company_id = company_admin.id
    if @branch.save
      redirect_to branches_path(company_id: @branch.id), notice: t('activerecord.attributes.link.created')
    else
      flash.now[:alert] = t('activerecord.attributes.link.failed_to_create')
      render 'new'
    end
  end

  def edit
  end

  def update
    @branch.update(branch_params)
    if @branch.update(branch_params)
      redirect_to branches_path, notice: t('activerecord.attributes.link.updated')
    else
      flash[:notice] = t('activerecord.attributes.link.failed_to_create')
      render 'branches/edit'
    end
  end

  def destroy
    @branch.destroy
    redirect_to branches_path, notice: t('activerecord.attributes.link.canceled')
  end

  private
    def find_branch
        @branch = Branch.find(params[:id])
    end

    def branch_params
      params.require(:branch).permit(:name, :address, :phone, :company_id, :calendar_start_time, :calendar_end_time,
         :makable_reservation_hour_span, :cancelable_reservation_hour_span, :ticket_price, :email, :secret_code)
    end
end
