class MailingListsController < ApplicationController
  before_action :set_mailing_list, only: %i[ show edit update destroy ]

  def index
    @mailing_lists = MailingList.all
  end

  def show
  end

  def new
    @mailing_list = MailingList.new
  end

  def edit
  end

  def create
    @mailing_list = MailingList.new(mailing_list_params)

    if @mailing_list.save
      redirect_to mailing_lists_path, notice: "La mailing list a été créée avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @mailing_list.update(mailing_list_params)
      redirect_to mailing_lists_path, notice: "La mailing list a été mise à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @mailing_list.destroy
    redirect_to mailing_lists_url, notice: "La mailing list a été supprimée avec succès."
  end

  private
    def set_mailing_list
      @mailing_list = MailingList.find(params[:id])
    end

    def mailing_list_params
      params.require(:mailing_list).permit(:name, :text, :site_id)
    end
end

