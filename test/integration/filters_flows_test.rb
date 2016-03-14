require 'test_helper'
class FiltersFlowsTest < ActionDispatch::IntegrationTest

  setup do
    $redis.flushall
    page.driver.browser.manage.window.resize_to(1350,768)
  end

  test 'home' do
    visit '/'
    page.must_have_content('Contatos')
  end

  test 'should have positions list' do
    visit '/'
    positions = Position.all
    positions_divs = page.all(:css, '.position-item')
    assert_equal positions.size, positions_divs.size
    assert_equal false, page.has_content?("Nenhum cargo cadastrado.")

    positions_divs = positions_divs.map do |positions_div|
      positions_div.text
    end.join(' ')

    positions.each do |position|
      assert_includes positions_divs, position.name
    end
  end

  test 'positions empty state' do
    Contact.delete_all
    Position.delete_all

    visit '/'
    assert_equal 0, page.all(:css, '.position-item').size
    assert_equal true, page.has_content?("Nenhum cargo cadastrado.")
  end

  test 'positions get API error' do
    Capybara.javascript_driver = :selenium_billy
    Capybara.current_driver = Capybara.javascript_driver

    page.driver.browser.manage.window.resize_to(1280,768)

    proxy.stub(/.*positions.*/).and_return(:code => 500)

    visit '/'
    sleep 1
    assert_equal page.find('.md-toast-text').text, 'Ops, algo deu errado. Isso não deveria acontecer mas fique tranquilo, logo será resolvido.'

    Capybara.javascript_driver = :selenium
    Capybara.current_driver = Capybara.javascript_driver
  end

  test 'should have states list' do
    visit '/'
    states = State.to_a
    states_divs = page.all(:css, '.state-item')
    assert_equal states.size, states_divs.size

    states_divs = states_divs.map do |states_div|
      states_div.text
    end.join(' ')

    states.each do |state|
      assert_includes states_divs, state[0]
    end
  end

  test 'states get API error' do
    Capybara.javascript_driver = :selenium_billy
    Capybara.current_driver = Capybara.javascript_driver

    page.driver.browser.manage.window.resize_to(1280,768)

    proxy.stub(/.*states.*/).and_return(:code => 500)

    visit '/'
    sleep 1
    assert_equal page.find('.md-toast-text').text, 'Ops, algo deu errado. Isso não deveria acontecer mas fique tranquilo, logo será resolvido.'

    Capybara.javascript_driver = :selenium
    Capybara.current_driver = Capybara.javascript_driver
  end

  test 'filters' do
    visit '/'

    page.find("#start-age").set(1) #workaround to ignore watcher rule
    page.find("#end-age").set(31)
    page.find("#start-age").set(30)

    click_button('Segmentar')

    sleep 1

    contacts = [contacts(:one), contacts(:six)]
    contacts_divs = page.all(:css, '.contact-item')
    assert_equal contacts.size, contacts_divs.size
    assert_equal false, page.has_content?("Nenhum contato cadastrado.")

    contacts_divs = contacts_divs.map do |contacts_div|
      contacts_div.text
    end.join(' ')

    contacts.each do |contact|
      assert_includes contacts_divs, contact.email
    end

    # With position #

    page.find("#position-checkbox-#{positions(:three).id}").click

    click_button('Segmentar')

    sleep 1

    contacts = [contacts(:six)]
    contacts_divs = page.all(:css, '.contact-item')
    assert_equal 1, contacts_divs.size
    assert_equal false, page.has_content?("Nenhum contato cadastrado.")

    contacts_divs = contacts_divs.map do |contacts_div|
      contacts_div.text
    end.join(' ')

    assert_includes contacts_divs, contacts(:six).email

    # With state #

    page.find("#state-checkbox-24").click

    click_button('Segmentar')

    sleep 1

    contacts_divs = page.all(:css, '.contact-item')
    assert_equal 0, contacts_divs.size
  end

  test 'filters with save' do
    visit '/'

    # Without clicking on save button #

    page.find("#start-age").set(1) #workaround to ignore watcher rule
    page.find("#end-age").set(31)
    page.find("#start-age").set(30)
    page.find("#position-checkbox-#{positions(:three).id}").click
    page.find("#state-checkbox-24").click

    assert_equal 0, $redis.smembers('segments').size

    click_button('Segmentar')
    sleep 1

    assert_equal 0, $redis.smembers('segments').size

    # Clicking on save button #

    page.find("#save-segment-checkbox").click

    click_button('Segmentar')
    sleep 1

    assert_equal 1, $redis.smembers('segments').size
  end

  test 'filter positions by name' do
    visit '/'

    page.find('#position-search-name').set(positions(:three).name)

    positions_divs = page.all(:css, '.position-item')
    assert_equal 1, positions_divs.size
    assert_equal false, page.has_content?("Nenhum cargo cadastrado.")

    positions_divs = positions_divs.map do |positions_div|
      positions_div.text
    end.join(' ')

    assert_includes positions_divs, positions(:three).name

    page.find('#position-search-name').set('whatever')
    positions_divs = page.all(:css, '.position-item')
    assert_equal 0, positions_divs.size
  end

end