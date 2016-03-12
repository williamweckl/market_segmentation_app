#encoding: UTF-8
class PositionsController < ApplicationController

  def index
    @positions = Position.all
    return render json: @positions
  end

end