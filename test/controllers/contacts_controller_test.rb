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

  test 'return filtered by state' do
    get :index, params: {states: State::SC.to_s}
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:one).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:two).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:three).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:four).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:five).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:six).name }.with_indifferent_access

    get :index, params: {states: State::RR.to_s}
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:four).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:two).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:three).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:one).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:five).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:six).name }.with_indifferent_access
  end

  test 'return filtered by states' do
    get :index, params: {states: [State::SC, State::PR].join(',')}
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:one).name }.with_indifferent_access
    assert_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:two).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:three).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:four).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:five).name }.with_indifferent_access
    assert_not_includes json.map{|contact| {'name' => contact['name']}}, { name: contacts(:six).name }.with_indifferent_access
  end

  test 'saving filters' do
    $redis.flushall #reset redis database
    filters = {position_ids: [positions(:one).id, positions(:three).id].join(',')}

    get :index, params: filters
    assert_equal $redis.smembers('segments').size, 0
    get :index, params: {save: ''}.merge(filters)
    assert_equal $redis.smembers('segments').size, 0
    get :index, params: {save: 'false'}.merge(filters)
    assert_equal $redis.smembers('segments').size, 0
    get :index, params: {save: '0'}.merge(filters)
    assert_equal $redis.smembers('segments').size, 0
    get :index, params: {save: 0}.merge(filters)
    assert_equal $redis.smembers('segments').size, 0
    get :index, params: {save: false}.merge(filters)
    assert_equal $redis.smembers('segments').size, 0

    get :index, params: {save: 'true'}.merge(filters)
    assert_equal $redis.smembers('segments').size, 1
    get :index, params: {save: '1'}.merge(start_age: '30', end_age: '50')
    assert_equal $redis.smembers('segments').size, 2
    get :index, params: {save: 1}.merge(start_age: '31', end_age: '50')
    assert_equal $redis.smembers('segments').size, 3
    get :index, params: {save: true}.merge(start_age: '33', end_age: '50')
    assert_equal $redis.smembers('segments').size, 4

    # Should not save duplicates
    get :index, params: {save: 'true'}.merge(filters)
    assert_equal $redis.smembers('segments').size, 4
  end


end
