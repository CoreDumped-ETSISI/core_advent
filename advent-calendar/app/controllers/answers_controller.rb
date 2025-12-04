class AnswersController < ApplicationController
  before_action :set_answer, only: %i[ show edit update destroy ]
  before_action :set_problem
  authorize_resource

  # GET /answers or /answers.json
  def index
    @answers = @problem.answers
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
          format.html { redirect_to @problem, notice: "¡Respuesta correcta!" }
        elsif save
          format.html { redirect_to @problem, notice: "¡Respuesta incorrecta!" }
        else
          format.html { render "problems/show", status: :unprocessable_entity }
        end
      else
        # Problem is locked: check answer but don't save
        if now < @problem.unlock_time
          # Not yet unlocked
          format.html { redirect_to @problem, notice: "Este problema aún no está disponible." }
        elsif now >= @problem.lock_time
          # Already locked: check answer but don't save
          if @answer.correct
            format.html { redirect_to @problem, notice: "¡Respuesta correcta! (No guardada - problema bloqueado)" }
          else
            format.html { redirect_to @problem, notice: "¡Respuesta incorrecta! (No guardada - problema bloqueado)" }
          end
        else
          # No timing set or other edge case
          format.html { redirect_to @problem, notice: "La configuración de tiempo del problema no está configurada correctamente." }
        end
      end
    end
  end

  # PATCH/PUT /answers/1 or /answers/1.json
  def update
    respond_to do |format|
      # Recalculate correct before updating
      @answer.assign_attributes(answer_params)
      @answer.correct = @answer.answer_text.downcase.strip === @problem.correct_answer
      
      if @answer.save
        format.html { redirect_to problem_answer_path, notice: "Respuesta actualizada con éxito." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1 or /answers/1.json
  def destroy
    @answer.destroy!

    respond_to do |format|
      format.html { redirect_to problem_answers_path, status: :see_other, notice: "Respuesta borrada con éxito." }
      format.json { head :no_content }
    end
  end
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: "No estás autorizad@ para acceder a esa página." }
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
