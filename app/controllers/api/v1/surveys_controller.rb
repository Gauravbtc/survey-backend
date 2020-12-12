module Api::V1
  class SurveysController < ApiBaseController
    before_action :set_survey, only: [:show, :update, :destroy]

    def index
      surveys = @user.surveys.order(created_at: :desc)
      survey_response(true, I18n.t("survey.list"), surveys)
    end

    def show
      survey_response(true, I18n.t("survey.list"), @survey.format_json)
    end

    def create
      ## verify user input parameters
      parameter_missing?(%w[title description user_id questions_attributes] , survey_params)
      survey = Survey.new(survey_params)
      if survey.save
        survey_response(true, I18n.t("survey.created"), survey)
      else
        survey_response(false, I18n.t("survey.errors", msg: "create"), survey.errors)
      end
    end

    def update
      parameter_missing?(%w[title description user_id questions_attributes] , survey_update_params)
      if @survey.update(survey_update_params)
        survey_response(true, I18n.t("survey.updated"), @survey)
      else
        survey_response(false, I18n.t("survey.errors", msg: "update"), @survey.errors)
      end
    end

    def destroy
      @survey.destroy
      survey_response(true, I18n.t("deleted"), {})
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def survey_params
      params.require(:survey).permit(:title, :description, :user_id, questions_attributes: [:title, options: []])
    end

    def survey_update_params
      params.require(:survey).permit(:id, :title, :description, :user_id, questions_attributes: [ :id, :title, options: []])
    end

    def survey_response(success, message, data)
      json_response({ success: success, message: message, data: data })
    end
  end
end