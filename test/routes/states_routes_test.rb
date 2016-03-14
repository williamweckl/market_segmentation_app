require 'test_helper'
class StatesRoutesTest < ActionDispatch::IntegrationTest

  test 'states routes' do
    params = {controller: 'states', action: "index", format: :json}
    assert_routing({path: '/states', method: :get}, params)
  end

end