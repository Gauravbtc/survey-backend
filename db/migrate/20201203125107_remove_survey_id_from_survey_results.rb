class RemoveSurveyIdFromSurveyResults < ActiveRecord::Migration[6.0]
  def change
    remove_column :survey_results, :survey_id
  end
end
