require 'test_helper'
class SegmentsFlowsTest < ActionDispatch::IntegrationTest

  let(:segments) do
    [
        {age: '30'},
        {start_age: '40', end_age: '51'},
        {position_ids: positions(:one).id.to_s, positions: [positions(:one).name]},
        {states: '1,2,3', state_names: ['Acre', 'Alagoas', 'Amapá']},
    ]
  end

  def create_segments
    segments.each do |segment|
      $redis.sadd('segments', segment.to_json)
    end
  end

  setup do
    page.driver.browser.manage.window.resize_to(1280,768)
  end

  test 'should open dialog with segments' do
    visit '/'
    assert_equal false, page.has_content?("Segmentos")
    assert_equal false, page.has_selector?("#segments-dialog", visible: true)
    assert_equal false, page.has_selector?("#segments-list", visible: true)

    find("#segments-list-button").click
    sleep 1
    assert_equal true, page.has_content?("Segmentos")
    assert_equal true, page.has_selector?("#segments-dialog", visible: true)
    assert_equal true, page.has_selector?("#segments-list", visible: true)
  end

  test 'should have segments list' do
    $redis.flushall
    create_segments

    visit '/'
    find("#segments-list-button").click
    sleep 1

    segments_divs = page.all(:css, '.segment-item')

    assert_equal segments.size, segments_divs.size
    assert_equal false, page.has_content?("Nenhum segmento salvo.")

    segments_divs.each_with_index do |segments_div, index|
      segment = segments[index]
      position_text = "Cargos: #{segment[:positions].join(', ')}" if segment[:positions]
      state_text = "Estados: #{segment[:state_names].join(', ')}" if segment[:state_names]
      age_text = "Idade: #{segment[:age]} anos" if segment[:age]
      age_start_end_text = "Idade: de #{segment[:start_age]} até #{segment[:end_age]} anos" if segment[:start_age]

      assert_includes segments_div.text, position_text if position_text
      assert_includes segments_div.text, state_text if state_text
      assert_includes segments_div.text, age_text if age_text
      assert_includes segments_div.text, age_start_end_text if age_start_end_text
    end
  end

  test 'segments empty state' do
    $redis.flushall
    visit '/'
    find("#segments-list-button").click
    sleep 1
    assert_equal 0, page.all(:css, '.segment-item').size
    assert_equal true, page.has_content?("Nenhum segmento salvo.")
  end

  test 'segment click should filter contact list' do
    $redis.flushall
    $redis.sadd('segments', {age: '30'}.to_json)

    visit '/'
    find("#segments-list-button").click
    sleep 1

    segments_divs = page.all(:css, '.segment-item')
    element = segments_divs.first

    element.click
    sleep 1

    # Should hide dialog
    assert_equal false, page.has_content?("Segmentos")
    assert_equal false, page.has_selector?("#segments-dialog", visible: true)
    assert_equal false, page.has_selector?("#segments-list", visible: true)

    contacts_divs = page.all(:css, '.contact-item')
    assert_equal 1, contacts_divs.size
    assert_equal false, page.has_content?("Nenhum contato cadastrado.")

    contacts_divs = contacts_divs.map do |contacts_div|
      contacts_div.text
    end.join(' ')

    # contacts(:one) is the only 30 years old
    assert_includes contacts_divs, contacts(:one).email
  end

end