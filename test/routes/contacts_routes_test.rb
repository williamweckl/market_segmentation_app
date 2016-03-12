require 'test_helper'
class ContactsRoutesTest < ActionDispatch::IntegrationTest

  test 'contacts routes' do
    params = {controller: 'contacts', action: "index", format: :json}
    assert_routing({path: '/contacts', method: :get}, params)
  end

end