#encoding: UTF-8
class ContactsController < ApplicationController

  def index
    @contacts = Contact.all
    apply_filters
    paginable
    saveable
    return render json: @contacts
  end

  private

  def apply_filters
    @contacts = @contacts.by_position_ids(params[:position_ids].split(',')) unless params[:position_ids].blank?
    @contacts = @contacts.by_states(params[:states].split(',')) unless params[:states].blank?
    if !params[:age].blank?
      @contacts = @contacts.by_age(params[:age])
    else
      @contacts = @contacts.by_age_range(params[:start_age], params[:end_age]) if !params[:start_age].blank? || !params[:end_age].blank?
    end
  end

  def paginable
    @contacts = @contacts.paginate(:page => params[:page], :per_page => params[:per_page] || 30) if params[:page]
  end

  def saveable
    if !params[:save].blank? and (params[:save] == true || params[:save].to_s == 'true' || params[:save].try(:to_i) == 1)
      $redis.sadd('segments', {
          age: params[:age],
          start_age: params[:start_age],
          end_age: params[:end_age],
          position_ids: params[:position_ids],
          states: params[:states]
      }.to_json)
    end
  end

end