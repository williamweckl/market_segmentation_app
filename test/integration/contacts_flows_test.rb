require 'test_helper'
class ContactsFlowsTest < ActionDispatch::IntegrationTest

  teardown do
    $redis.flushall
  end

  test 'home' do
    visit '/'
    page.must_have_content('Contatos')
  end

  test 'should have contacts list' do
    visit '/'
    contacts = Contact.all
    contacts_divs = page.all(:css, '.contact-item')
    assert_equal contacts.size, contacts_divs.size
    assert_equal false, page.has_content?("Nenhum contato cadastrado.")

    contacts_divs = contacts_divs.map do |contacts_div|
      contacts_div.text
    end.join(' ')

    contacts.each do |contact|
      assert_includes contacts_divs, contact.email
    end
  end

  test 'contacts empty state' do
    Contact.delete_all

    visit '/'
    assert_equal 0, page.all(:css, '.contact-item').size
    assert_equal true, page.has_content?("Nenhum contato cadastrado.")
  end

  test 'contacts get API error' do
    Capybara.javascript_driver = :selenium_billy
    Capybara.current_driver = Capybara.javascript_driver

    page.driver.browser.manage.window.resize_to(1280,768)

    proxy.stub(/.*contacts.*/).and_return(:code => 500)

    visit '/'
    sleep 1
    assert_equal page.find('.md-toast-text').text, 'Ops, algo deu errado. Isso não deveria acontecer mas fique tranquilo, logo será resolvido.'

    Capybara.javascript_driver = :selenium
    Capybara.current_driver = Capybara.javascript_driver
  end

  test 'filters sidenav should be opened in resolutions above 1280px' do
    page.driver.browser.manage.window.resize_to(1280,768)

    visit '/'
    assert_equal true, page.has_content?("Segmentar")

    page.driver.browser.manage.window.resize_to(1279,768)

    visit '/'
    assert_equal false, page.has_content?("Segmentar")
  end

  test 'filters sidenav should be toggled when clicking the filters button' do
    page.driver.browser.manage.window.resize_to(1279,768)

    visit '/'
    assert_equal false, page.has_selector?("md-sidenav[md-component-id='filters']", visible: true)

    find("#filters-btn").click
    assert_equal true, page.has_selector?("md-sidenav[md-component-id='filters']", visible: true)

    find("#content").click
    sleep 1
    assert_equal false, page.has_selector?("md-sidenav[md-component-id='filters']", visible: true)
  end

end