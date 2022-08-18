module Accessible
    extend ActiveSupport::Concern
    included do
      prepend_before_action :check_user
    end
  
    protected
    def check_user
      if current_company
        flash[:notice] = '企業として既にログインしています。'
        redirect_to(root_path) and return
      elsif current_staff
        flash[:notice] = 'スタッフとして既にログインしています。'
        redirect_to(root_path) and return
      elsif current_user
        flash[:notice] = 'ユーザーとして既にログインしています。'
        redirect_to(root_path) and return
      end
    end
  end