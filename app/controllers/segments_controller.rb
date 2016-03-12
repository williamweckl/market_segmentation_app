#encoding: UTF-8
class SegmentsController < ApplicationController

  def index
    @segments = $redis.smembers('segments').map{|segment| JSON::parse(segment)}
    return render json: @segments
  end

end