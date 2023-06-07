class SitesController < ApplicationController
  before_action :set_site, only: %i[ edit update destroy ]
  before_action :require_role

  def require_role
    unless current_user&.role == true
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  # GET /sites or /sites.json
  def index
    @sites = Site.all
  end

  # GET /sites/new
  def new
    @site = Site.new
  end

  # GET /sites/1/edit
  def edit
  end

  # POST /sites or /sites.json
  def create
    @site = Site.new(site_params)
  
    respond_to do |format|
      if @site.save
        format.html { redirect_to site_url(@site), notice: "Le site a bien été créé !" }
        format.json { render :show, status: :created, location: @site }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sites/1 or /sites/1.json
  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to site_url(@site), notice: "Le site a bien été modifié !" }
        format.json { render :show, status: :ok, location: @site }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1 or /sites/1.json
  def destroy
    @site.destroy

    respond_to do |format|
      format.html { redirect_to sites_url, notice: "Le site a bien été supprimé !" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Site.find(params[:id])
    end

    def set_cdom_name
      @site = Site.find(params[:id])
      @cdom_name = @site.cdom.name
    end

    # Only allow a list of trusted parameters through.
    def site_params
      params.require(:site).permit(:name, :address, :postal_code, :city, :software, :informations, :cdom_id, :color)
    end
end
