class CdomsController < ApplicationController
  before_action :set_cdom, only: %i[ show edit update destroy ]
  before_action :require_role

  def require_role
    unless current_user&.role == true
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  # GET /cdoms or /cdoms.json
  def index
    if params[:search]
      @pagy, @cdoms = pagy(Cdom.search_by_name(params[:search]), items: 10)
    else
      @pagy, @cdoms = pagy(Cdom.all, items: 10)
    end
  end

  # GET /cdoms/1 or /cdoms/1.json
  def show
  end

  # GET /cdoms/new
  def new
    @cdom = Cdom.new
  end

  # GET /cdoms/1/edit
  def edit
  end

  def create
    @cdom = Cdom.new(cdom_params)
  
    respond_to do |format|
      if @cdom.save
        format.html { redirect_to cdoms_path, notice: "Le site du Conseil de l'Ordre a bien été créé !" }
        format.json { render :show, status: :created, location: @cdom }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cdom.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @cdom.update(cdom_params)
        format.html { redirect_to cdoms_path, notice: "Le site du Conseil de l'Ordre a bien été modifié !" }
        format.json { render :show, status: :ok, location: @cdom }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cdom.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /cdoms/1 or /cdoms/1.json
  def destroy
    if @cdom.sites.empty?
      @cdom.destroy
      respond_to do |format|
        format.html { redirect_to cdoms_url, notice: "Le site du Conseil de l'Ordre a bien été supprimé !" }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to cdoms_url, alert: "Le cdom est associé à des sites et ne peut pas être supprimé." }
        format.json { head :unprocessable_entity }
      end
    end
  end
  
  private
    def set_cdom
      @cdom = Cdom.find(params[:id])
    end

    def cdom_params
      params.require(:cdom).permit(:id, :departement, :name, :email)
    end

end
