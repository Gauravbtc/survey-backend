class CreateSurveyResults < ActiveRecord::Migration[6.0]
  def change
    create_table :survey_results do |t|
      t.references :survey, foreign_key: true
      t.references :participant, foreign_key: true
      t.references :question, foreign_key: true
      t.string :ans, null: false
      t.timestamps
    end
  end
end
