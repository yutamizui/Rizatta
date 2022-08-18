class StaffsController < ApplicationController
  def index
    @staffs = Staff.where(branch_id: params[:branch_id])
    @branches = current_company.branches
  end
end
