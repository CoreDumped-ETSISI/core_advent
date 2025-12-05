class ProblemsController < ApplicationController
  before_action :set_problem, only: %i[ show edit update destroy ]
  authorize_resource except: [ :year_index, :index ]

  # GET /
  def year_index
    accessible_problems = Problem.accessible_by(current_ability)
    @years = accessible_problems.select("DISTINCT strftime('%Y',unlock_time) AS year")
                                .order("year DESC")
                                .map { |e| e.year.to_i }
  end
  # GET /:year
  def index
    @year = params.expect(:year)
    @problems = Problem.for_year @year
    # Only show problems that the user can read (unlocked ones)
    @problems = @problems.accessible_by(current_ability)
    @problems = @problems.order("unlock_time ASC")

    if @problems.size === 0
      render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end
  end

  # GET /problems/1 or /problems/1.jsons
  def show
    @answer = @problem.answers.build
  end

  # GET /problems/new
  def new
    @problem = Problem.new
  end

  # GET /problems/1/edit
  def edit
  end

  # POST /problems or /problems.json
  def create
    @problem = Problem.new(problem_params)

    respond_to do |format|
      if @problem.save
        format.html { redirect_to @problem, notice: "Problema creado con éxito." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /problems/1 or /problems/1.json
  def update
    respond_to do |format|
      if @problem.update(problem_params)
        format.html { redirect_to @problem, notice: "Problema actualizado con éxito." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /problems/1 or /problems/1.json
  def destroy
    @problem.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, status: :see_other, notice: "Problema borrado con éxito." }
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: "No estás autorizad@ para acceder a esa página." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def problem_params
      params.expect(problem: [ :title, :content, :correct_answer, :lock_time, :unlock_time ])
    end
end
