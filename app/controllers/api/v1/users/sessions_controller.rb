# frozen_string_literal: true
module Api::V1
  class Users::SessionsController < Devise::SessionsController
    include Response
    include ExceptionHandler
    skip_before_action :verify_signed_out_user, only: :destroy

    def create
      parameter_missing?(%w[email password], user_params)
      resource = User.find_for_database_authentication(email: user_params[:email])
      if resource.present? && resource.valid_password?(user_params[:password])
        auth_token = Auth.encode({user: resource.id})
        resource.update_attributes(auth_token: auth_token)
        user = resource.user_to_json
        json_response({ success: true,
                        message: I18n.t("users.login_success"),
                        data: user })
      else
        invalid_login_attempt
      end
    end

    def destroy
      user = User.find_by(auth_token: request.headers['HTTP_AUTH_TOKEN'])
      if request.headers['HTTP_AUTH_TOKEN'].blank? || user.blank?
        json_response({ success: false,
                        message: I18n.t("users.invalid_auth_token"),
                        data: {} })
      else
        user.update(auth_token: nil)
        json_response({ success: true,
                        message: I18n.t("users.signout_success"),
                        data: {} })
      end
    end

  protected

    def user_params
      params.require(:user).permit(:email, :password)
    end

    def invalid_login_attempt
      warden.custom_failure!
      json_response({ success: false,
                        message: I18n.t("users.invalid_login"),
                        data: {} })
    end

    def parameter_missing?(check_parameters = [], parameters = {})
      missing_params = []
      missing_params << check_parameters.select { |p| parameters[p].to_s.strip.blank? }
      if missing_params.flatten!.present?
        raise ArgumentError, I18n.t("users.required_login")
      end
    end
  end
end