#encoding: UTF-8
class SegmentsController < ApplicationController

  def index
    @segments = []
    $redis.smembers('segments').each do |segment|
      segment_parsed = JSON::parse(segment)
      hash = {}
      hash[:age] = segment_parsed['age'] if segment_parsed['age']
      hash[:start_age] = segment_parsed['start_age'] if segment_parsed['start_age']
      hash[:end_age] = segment_parsed['end_age'] if segment_parsed['end_age']
      if segment_parsed['position_ids']
        hash[:position_ids] = segment_parsed['position_ids'].split(',')
        hash[:positions] = []
        hash[:position_ids].each do |position_id|
          hash[:positions] << Position.find_by(id: position_id).try(:name)
        end
      end
      @segments << hash
    end

    return render json: @segments.reverse!
  end

end