require 'test_helper'
class SegmentsControllerTest < ActionController::TestCase

  test 'have ok status' do
    get :index
    assert_equal response.content_type, Mime[:json]
    assert_response :ok
  end

  test 'return segments' do
    segment = {age: '30'}
    $redis.sadd('segments', segment.to_json)

    get :index
    assert_includes json, segment.with_indifferent_access
  end

end
