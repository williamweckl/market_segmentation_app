require 'test_helper'
class ContactsControllerTest < ActionController::TestCase

  test 'have ok status' do
    get :index
    assert_equal response.content_type, Mime[:json]
    assert_response :ok
  end

  test 'return contacts' do
    get :index
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:one).name }.with_indifferent_access
  end

  test 'return paginated contacts' do
    get :index
    assert_equal true, json.size >= 3

    get :index, params: {page: 1, per_page: 2}
    assert_equal 2, json.size

    get :index, params: {page: 2, per_page: 2}
    assert_equal 2, json.size
  end

  test 'return filtered by age' do
    get :index, params: {age: '30'}
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:one).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:two).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:three).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:four).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:five).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:six).name }.with_indifferent_access

    get :index, params: {start_age: '30'}
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:two).name }.with_indifferent_access
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:four).name }.with_indifferent_access
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:five).name }.with_indifferent_access
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:six).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:one).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:three).name }.with_indifferent_access

    get :index, params: {end_age: '30'}
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:three).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:one).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:two).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:four).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:five).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:six).name }.with_indifferent_access

    get :index, params: {start_age: '30', end_age: '50'}
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:two).name }.with_indifferent_access
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:five).name }.with_indifferent_access
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:six).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:one).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:three).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:four).name }.with_indifferent_access
  end

  test 'return filtered by position_id' do
    get :index, params: {position_ids: positions(:one).id.to_s}
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:one).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:two).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:three).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:four).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:five).name }.with_indifferent_access
  end

  test 'return filtered by position_ids' do
    get :index, params: {position_ids: [positions(:one).id, positions(:three).id].join(',')}
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:one).name }.with_indifferent_access
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:five).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:two).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:three).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:four).name }.with_indifferent_access
  end
end
