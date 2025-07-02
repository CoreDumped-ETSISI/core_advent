class AnswersController < ApplicationController
  before_action :set_answer, only: %i[ show edit update destroy ]
  before_action :set_problem

  # GET /answers or /answers.json
  def index
    @answers = Answer.all
  end

  # GET /answers/1 or /answers/1.json
  def show
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
  end

  # POST /answers or /answers.json
  def create
    @answer = @problem.answers.build(answer_params)
    @answer.correct = @answer.answer_text.downcase.trim === @problem.correct_answer

    respond_to do |format|
      save = @answer.save
      if save and @answer.correct
        format.html { redirect_to @problem, notice: "Correct answer!" }
      elsif save
        format.html { redirect_to @problem, notice: "Incorrect answer!" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answers/1 or /answers/1.json
  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to @answer, notice: "Answer was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1 or /answers/1.json
  def destroy
    @answer.destroy!

    respond_to do |format|
      format.html { redirect_to problem_answers_path, status: :see_other, notice: "Answer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params.expect(:id))
    end
    def set_problem
      @problem = Problem.find(params[:problem_id])
    end
    # Only allow a list of trusted parameters through.
    def answer_params
      params.expect(answer: [ :answer_text ])
    end
end
