class MailingListsController < ApplicationController
  before_action :require_role
  before_action :set_mailing_list, only: %i[ edit update destroy ]

  def require_role
    unless current_user&.role == true
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  # GET /mailing_lists or /mailing_lists.json
  def index
    @mailing_lists = MailingList.all
  end

  # GET /mailing_lists/new
  def new
    @mailing_list = MailingList.new
  end

  # GET /mailing_lists/1/edit
  def edit
  end

  # POST /mailing_lists or /mailing_lists.json
  def create
    @mailing_list = MailingList.new(mailing_list_params)

    respond_to do |format|
      if @mailing_list.save
        format.html { redirect_to mailing_list_url(@mailing_list), notice: "La Mailing list a bien été créée !" }
        format.json { render :show, status: :created, location: @mailing_list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mailing_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mailing_lists/1 or /mailing_lists/1.json
  def update
    respond_to do |format|
      if @mailing_list.update(mailing_list_params)
        format.html { redirect_to mailing_list_url(@mailing_list), notice: "La Mailing list a bien été modifiée !" }
        format.json { render :show, status: :ok, location: @mailing_list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mailing_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mailing_lists/1 or /mailing_lists/1.json
  def destroy
    @mailing_list.destroy
    
    respond_to do |format|
      format.html { redirect_to mailing_lists_url, notice: "La Mailing list a bien été supprimée !" }
      format.json { head :no_content }
    end
  end
  
  private
    def set_mailing_list
      @mailing_list = MailingList.find(params[:id])
    end

    def mailing_list_params
      params.require(:mailing_list).permit(:name, :text, :site_id)
    end
end
