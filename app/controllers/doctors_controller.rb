class DoctorsController < ApplicationController
  before_action :set_doctor, only: %i[ edit create update destroy ]
  before_action :require_role

  def require_role
    unless current_user&.role == true
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  # GET /doctors or /doctors.json
  def index
    if params[:search]
      @pagy, @doctors = pagy(Doctor.search_by_name(params[:search]), items: 10)
    else
      @pagy, @doctors = pagy(Doctor.all, items: 10)
    end
  end

  # GET /doctors/new
  def new
    @doctor = Doctor.new
  end

  # GET /doctors/1/edit
  def edit
  end

  # POST /doctors or /doctors.json
  def create
    @doctor = Doctor.new(doctor_params)

    respond_to do |format|
      if @doctor.save
        format.html { redirect_to doctor_url(@doctor), notice: "Le profil médecin a bien été créé !" }
        format.json { render :show, status: :created, location: @doctor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doctors/1 or /doctors/1.json
  def update
    respond_to do |format|
      if @doctor.update(doctor_params)
        format.html { redirect_to doctor_url(@doctor), notice: "Le profil médecin a bien été mis à jour !" }
        format.json { render :show, status: :ok, location: @doctor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doctors/1 or /doctors/1.json
  def destroy
    @doctor.destroy

    respond_to do |format|
      format.html { redirect_to doctors_url, notice: "Le profil médecin a bien été supprimé !" }
      format.json { head :no_content }
    end
  end

  private
    def set_doctor
      @doctor = Doctor.find(params[:id]) unless action_name == "create"
    end

    def doctor_params
      params.require(:doctor).permit(:title, :last_name, :first_name, :rpps, :speciality, :conventional_sector, :optam, :phone, :email, :signature, :instructions)
    end
    
end
