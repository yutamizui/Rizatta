class ApplicationController < ActionController::Base
    before_action :set_locale
    before_action :configure_permitted_parameters, if: :devise_controller?


    def set_locale
      if ["ja", "en"].include?(cookies[:locale])
        I18n.locale = cookies[:locale]
      end
    end

    def locale
        if %w(ja en).include?(params[:locale])
          cookies[:locale] = params[:locale]
          if current_company.present?
            redirect_to controller: :branches, action: :index
          elsif current_user.present?
            redirect_to reservations_path
          else
            redirect_to new_user_session_path
          end
        end
      end

    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :phone, :address, :status, :secret_code, :company_id, :branch_id])
        devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :phone, :address, :status, :secret_code, :branch_id, :company_id, :password])
    end
end
  