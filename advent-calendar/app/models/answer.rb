class Answer < ApplicationRecord
  belongs_to :problem

  validates :problem, presence: true
  validates :answer_text, presence: true
  validates :correct, presence: true
end
