class AnswersController < ApplicationController
  before_action :set_answer, only: %i[ show edit update destroy ]
  before_action :set_problem
  authorize_resource

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
    @answer.user = current_user
    @answer.correct = @answer.answer_text.downcase.strip === @problem.correct_answer
    
    # Check if problem is currently unlocked (between unlock_time and lock_time)
    now = Time.current
    is_unlocked = now >= @problem.unlock_time && now < @problem.lock_time
    
    respond_to do |format|
      if is_unlocked
        # Normal flow: save to database
        save = @answer.save
        if save && @answer.correct
          format.html { redirect_to @problem, notice: "Correct answer!" }
        elsif save
          format.html { redirect_to @problem, notice: "Incorrect answer!" }
        else
          format.html { render 'problems/show', status: :unprocessable_entity }
        end
      else
        # Problem is locked: check answer but don't save
        if now < @problem.unlock_time
          # Not yet unlocked
          format.html { redirect_to @problem, notice: "This problem is not yet available." }
        elsif now >= @problem.lock_time
          # Already locked: check answer but don't save
          if @answer.correct
            format.html { redirect_to @problem, notice: "Correct answer! (Not saved - problem is locked)" }
          else
            format.html { redirect_to @problem, notice: "Incorrect answer! (Not saved - problem is locked)" }
          end
        else
          # No timing set or other edge case
          format.html { redirect_to @problem, notice: "Problem timing not configured properly." }
        end
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
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
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
