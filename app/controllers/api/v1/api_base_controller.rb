module Api::V1
  class ApiBaseController < ApplicationController
    include Response
    include ExceptionHandler

    before_action :authenticate_user
    skip_before_action :authenticate_user, only: [:create_survey_result, :show_survey_result, :verify_survey_auth, :survey_questions]

    def login_user
      user = User.find_by(auth_token: request.headers['HTTP_AUTH_TOKEN'])
      if user.present?
        render json: {success: true, message: "Login sucessfully",user: user }, status: 200
      else
        render json: {success: false, message: "Invalid auth token"}, status: 203
      end
    end

    def parameter_missing?(check_parameters = [], parameters = {})
      missing_params = []
      missing_params << check_parameters.select { |p| parameters[p].to_s.strip.blank? }
      if missing_params.flatten!.present?
        raise ArgumentError, "Check parameters"
      end
    end

    def login_user
      user = User.find_by(auth_token: request.headers['HTTP_AUTH_TOKEN'])
      if user.present?
        render json: {success: true, message: "Login sucessfully",user: user }, status: 200
      else
        render json: {success: false, message: "Invalid auth token"},status: 203
      end
    end

    private

    def authenticate_user
      unless devise_controller?
        user_token = request.headers['HTTP_AUTH_TOKEN']
        if user_token
          @user = User.find_by_auth_token(user_token)
          # @user.nil? ? return unauthorize : return @user
          if @user.nil?
            return unauthorize
          else
            return @user
          end
        else
          return unauthorize
        end
      end
    end

    def unauthorize
      render json: {success: false, message: "Invalid auth token "},status: 203
    end

  end
end