class Problem < ApplicationRecord
    has_rich_text :content

    has_many :answers, dependent: :destroy

    validates :title, presence: true
    validates :unlock_time, comparison: { less_than: :lock_time }
    validates :content, presence: true
    validates :correct_answer, presence: true
    before_save :clean_answer

    scope :for_year, ->(year) { where(unlock_time: Date.new(year.to_i).beginning_of_year..Date.new(year.to_i).end_of_year) }

    scope :available_years, -> {
    select("DISTINCT strftime('%Y',unlock_time) AS year")
    .order("year DESC")
    .map { |e| e.year.to_i }
  }

  private

  def clean_answer
    self.correct_answer.downcase!
    self.correct_answer.strip!
  end
end
