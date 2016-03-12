require 'test_helper'
class SegmentsRoutesTest < ActionDispatch::IntegrationTest

  test 'positions routes' do
    params = {controller: 'segments', action: "index", format: :json}
    assert_routing({path: '/segments', method: :get}, params)
  end

end