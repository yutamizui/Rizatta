class UsersController < ApplicationController
  def index
    @users = User.where(branch_id: params[:branch_id])
    @branches = current_company.branches
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.update(user_params)
      redirect_to users_path(branch_id: @user.branch_id), notice: t('activerecord.attributes.link.updated')
    else
      flash[:notice] = t('activerecord.attributes.link.failed_to_create')
      render 'users/edit'
    end
  end

  def destroy
  end

  private

    def user_params
      params.require(:user).permit(:name, :phone, :email)
    end
end
