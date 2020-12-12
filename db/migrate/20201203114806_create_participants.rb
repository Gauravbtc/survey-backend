class CreateParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :participants do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :survey_token, null: false
      t.string :survey_link, null: false
      t.references :survey, foreign_key: true
      t.string :survey_status, null: false, default: "shared"
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
