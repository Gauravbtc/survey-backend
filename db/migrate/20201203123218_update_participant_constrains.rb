class UpdateParticipantConstrains < ActiveRecord::Migration[6.0]
  def change
    change_column_null :participants, :survey_token, true
    change_column_null :participants, :survey_link, true
  end
end
