class CompaniesController < ApplicationController
  def index
    @branches = current_company.branches
    if params[:branch_id].present?
      @branch = Branch.find(params[:branch_id])
    else
      @branch = company_admin.branches.first
    end
    @users = @branch.users
  end

  def show
  end
end
