#encoding: UTF-8
class StatesController < ApplicationController

  def index
    @states = State.to_a.map{|state| {id: state[1], name: state[0]}}
    return render json: @states
  end

end