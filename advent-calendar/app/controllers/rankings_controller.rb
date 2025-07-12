class RankingsController < ApplicationController
  def index
    @year = params[:year]
    @ranking = User.ranking_for_year(@year)
  end
end