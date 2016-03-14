require 'test_helper'
class StatesControllerTest < ActionController::TestCase

  test 'have ok status' do
    get :index
    assert_equal response.content_type, Mime[:json]
    assert_response :ok
  end

  test 'return states' do
    get :index
    assert_includes json.map{|state| {'name' => state['name']}}, { name: 'Santa Catarina' }.with_indifferent_access
  end

end