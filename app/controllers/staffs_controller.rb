class StaffsController < ApplicationController
  def index
    @staffs = Staff.where(branch_id: params[:branch_id])
    @branches = company_admin.branches
  end

  def edit
    @staff = Staff.find(params[:id])
  end

  def update
    @staff = Staff.find(params[:id])
    @staff.update(staff_params)
    if @staff.update(staff_params)
      redirect_to staffs_path(branch_id: @staff.branch_id), notice: t('activerecord.attributes.link.updated')
    else
      flash[:notice] = t('activerecord.attributes.link.failed_to_create')
      render 'staffs/edit'
    end
  end

  def destroy
  end

  private

    def staff_params
      params.require(:staff).permit(:name, :phone, :email, :status, :company_id, :branch_id)
    end
end
