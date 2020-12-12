class SurveyResult < ApplicationRecord
  belongs_to :participant
  belongs_to :question
end
