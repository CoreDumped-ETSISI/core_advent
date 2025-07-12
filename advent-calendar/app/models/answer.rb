class Answer < ApplicationRecord
  belongs_to :problem
  belongs_to :user

  validates :problem, presence: true
  validates :answer_text, presence: true
  validate :check_cooldown_period, on: :create

  COOLDOWN_MINUTES = 5

  scope :user_has_correct_answer, ->(user, problem) {
    where(user_id: user.id, problem_id: problem.id, correct: true).exists?
  }

  # Scope to find recent incorrect answers within cooldown period
  scope :recent_incorrect_for_user_and_problem, ->(user_id, problem_id, minutes_ago = COOLDOWN_MINUTES) {
    where(
      user_id: user_id, 
      problem_id: problem_id, 
      correct: false,
      created_at: minutes_ago.minutes.ago..Time.current
    )
  }
  
  # Check if user can answer (not in cooldown)
  def self.user_can_answer?(user_id, problem_id)
    recent_incorrect_for_user_and_problem(user_id, problem_id).empty?
  end
  
  # Get remaining cooldown time in seconds
  def self.remaining_cooldown_time(user_id, problem_id)
    last_incorrect = where(
      user_id: user_id,
      problem_id: problem_id,
      correct: false
    ).order(created_at: :desc).first
    
    return 0 unless last_incorrect
    
    time_since_last = Time.current - last_incorrect.created_at
    cooldown_seconds = COOLDOWN_MINUTES * 60
    
    return 0 if time_since_last >= cooldown_seconds
    
    (cooldown_seconds - time_since_last).to_i
  end
  
  private
  
  def check_cooldown_period
    return if correct? # No cooldown for correct answers
    return if Answer.user_can_answer?(user_id, problem_id)
    
    remaining_time = Answer.remaining_cooldown_time(user_id, problem_id)
    minutes = (remaining_time / 60.0).ceil
    
    errors.add(:base, "You must wait #{minutes} more minute(s) before answering this problem again")
  end
end
