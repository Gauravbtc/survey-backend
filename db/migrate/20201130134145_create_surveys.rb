class CreateSurveys < ActiveRecord::Migration[6.0]
  def change
    create_table :surveys do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
