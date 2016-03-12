require 'test_helper'
class PositionsControllerTest < ActionController::TestCase

  test 'have ok status' do
    get :index
    assert_equal response.content_type, Mime[:json]
    assert_response :ok
  end

  test 'return positions' do
    get :index
    assert_includes json.map{|position| {'name' => position['name']}}, { name: positions(:one).name }.with_indifferent_access
  end

end
