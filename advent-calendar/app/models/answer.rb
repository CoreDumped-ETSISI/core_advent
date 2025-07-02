class Answer < ApplicationRecord
  belongs_to :problem
  belongs_to :user

  validates :problem, presence: true
  validates :answer_text, presence: true
  validates :correct, presence: true
end
