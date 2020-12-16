class Participant < ApplicationRecord
  has_many :survey_results, dependent: :destroy
  belongs_to :survey
  # validations
  validates_presence_of :name, :email, :user_id, :survey_id

  def self.survey_results_json(participant)
    survey_results_hash = {}
    participant_survey = self.includes(:survey_results, :survey).find_by(id: participant.id)
    survey_results_hash["participant_id"] = participant.id
    survey_results_hash["name"] = participant_survey.name
    survey_results_hash["email"] = participant_survey.email
    survey_results_hash["survey_id"] = participant.survey_id
    survey_results_hash["survey_token"] = participant.survey_token
    survey_results_hash["survey_date"] = participant_survey.created_at
    survey_results_hash["survey_name"] = participant_survey.survey.title
    survey_results_hash["questions_answers"] = participant_survey.survey_results.each_with_object([]) do | i, a |
                                            a << {question: i.question.title, ans: i.ans}
                                           end
    survey_results_hash

  end
end
