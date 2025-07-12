class User < ApplicationRecord
  has_secure_password

  has_many :answers, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true


  def self.ranking_for_year(year)
    # Get all users who have answered problems in the given year
    users_with_stats = User.joins(:answers)
                          .joins("JOIN problems ON problems.id = answers.problem_id")
                          .where(problems: { unlock_time: Date.new(year.to_i).beginning_of_year..Date.new(year.to_i).end_of_year })
                          .where(answers: { correct: true })
                          .group("users.id")
                          .select("users.*, 
                                   COUNT(DISTINCT problems.id) as problems_completed,
                                   SUM(julianday(answers.created_at) - julianday(problems.unlock_time)) * 86400 as total_time_seconds")
                          .order("problems_completed DESC, total_time_seconds ASC")

    # Convert to array and add ranking position
    ranking = users_with_stats.map.with_index(1) do |user, position|
      {
        position: position,
        user: user.username,
        problems_completed: user.problems_completed,
        total_time_seconds: user.total_time_seconds.to_f,
        average_time_per_problem: user.total_time_seconds.to_f / user.problems_completed
      }
    end

    ranking
  end

end
