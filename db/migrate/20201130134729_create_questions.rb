class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.string :options, array: true, default: []
      t.references :survey, foreign_key: true
      t.timestamps
    end
  end
end
