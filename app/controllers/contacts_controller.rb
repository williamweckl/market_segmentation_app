#encoding: UTF-8
class ContactsController < ApplicationController

  def index
    @contacts = Contact.all
    apply_filters
    paginable
    return render json: @contacts
  end

  private

  def apply_filters
    @contacts = @contacts.by_position_ids(params[:position_ids].split(',')) unless params[:position_ids].blank?
    if !params[:age].blank?
      @contacts = @contacts.by_age(params[:age])
    else
      @contacts = @contacts.by_age_range(params[:start_age], params[:end_age]) if !params[:start_age].blank? || !params[:end_age].blank?
    end
  end

  def paginable
    @contacts = @contacts.paginate(:page => params[:page], :per_page => params[:per_page] || 30) if params[:page]
  end

end