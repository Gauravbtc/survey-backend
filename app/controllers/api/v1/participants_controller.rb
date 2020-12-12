module Api::V1
  class ParticipantsController < ApiBaseController
    before_action :verify_survey_token, only: [:show_survey_result]

    def create
      ## verify user input parameters
      parameter_missing?(%w[name email user_id survey_id] , participant_params)
      participant = Participant.new(participant_params)
      if participant.save
        token = Auth.encode({participant: participant.id})
        participant.update(survey_token: token, survey_link: "#{Rails.application.secrets.react_app_host}=#{token}")
        participant_response(true, I18n.t("participant.created"), participant)
      else
        participant_response(false, I18n.t("participant.errors", msg: "create"), participant.errors)
      end
    end

    def create_survey_result
      parameter_missing?(%w[participant_id  survey_answers], survey_result_params)
      begin
        participant_id = survey_result_params[:participant_id]
        survey_results = []
        survey_result_params[:survey_answers].each {|result| survey_results << SurveyResult.create(participant_id: participant_id, question_id: result[:question_id], ans: result[:ans])}
        participant_response(true, I18n.t("participant.survey_results_created"), survey_results.as_json)
      rescue
        participant_response(false, I18n.t("participant.errors", msg: "create"), [])
      end
    end

    def show_survey_result
      result = Participant.survey_results_json(@valid_participant)
      participant_response(false, I18n.t("participant.qustion_ans_list"), result)
    end

    def verify_survey_auth
      participant_response(false, "Invalid token", {}) and return if request.headers['HTTP_SURVEY_TOKEN'].blank?
      participant = Participant.find_by(survey_token: request.headers['HTTP_SURVEY_TOKEN'])
      if participant.present?
        result = Participant.survey_results_json(participant)
        participant_response(true, I18n.t("participant.qustion_ans_list"), result)
      else
        participant_response(false, "Invalid token", {})
      end
    end

    def survey_questions
      survey = Survey.find(params[:survey_id])
      participant_response(true, I18n.t("survey.list"), survey.format_json)
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    def set_survey_details(participant)
    end


    # Only allow a list of trusted parameters through.
    def participant_params
      params.require(:participant).permit(:name, :email, :user_id, :survey_id)
    end

    def survey_result_params
      params.require(:survey_result).permit(:participant_id, survey_answers: [:question_id, :ans])
    end

    def verify_survey_token
      if request.headers['HTTP_SURVEY_TOKEN'].present?
         @valid_participant = Participant.find_by(id: params[:participant_id], survey_token: request.headers['HTTP_SURVEY_TOKEN'])
        if @valid_participant.present?
          @valid_participant
        else
          render json: {success: false, message: "Invalid token", data: {}}
        end
      else
        render json: {success: false, message: "Invalid token", data: {}}
      end
    end

    def participant_response(success, message, data)
      json_response({ success: success, message: message, data: data })
    end
  end
end