require 'test_helper'
class PositionsRoutesTest < ActionDispatch::IntegrationTest

  test 'positions routes' do
    params = {controller: 'positions', action: "index", format: :json}
    assert_routing({path: '/positions', method: :get}, params)
  end

end