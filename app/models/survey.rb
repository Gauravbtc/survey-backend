class Survey < ApplicationRecord
  # relations
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :participants

  # validations
  validates_presence_of :title, :user_id

  accepts_nested_attributes_for :questions, allow_destroy: true

  def format_json(options={})
    self.as_json(include: [:questions, :participants])
  end

end
