class Question < ApplicationRecord
  #relations
  belongs_to :survey

  # validations
  validates_presence_of :title
end
