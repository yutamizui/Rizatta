class UsersController < ApplicationController
  def index
    @users = User.where(branch_id: params[:branch_id])
    @branches = current_company.branches
  end
end
