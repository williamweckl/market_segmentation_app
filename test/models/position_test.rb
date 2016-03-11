require 'test_helper'
class PositionTest < ActiveSupport::TestCase

  subject { positions(:one) }
  let(:klass) { subject.class }

  # create_table :positions do |t|
  #   t.string :name, null: false
  #
  #   t.timestamps
  # end

  test 'translations' do
    #Attributes
    assert_equal klass.human_attribute_name("name"), I18n.t('attributes.name')
    assert_equal klass.human_attribute_name("created_at"), I18n.t('attributes.created_at')
    assert_equal klass.human_attribute_name("updated_at"), I18n.t('attributes.updated_at')

    #Model name
    assert_equal klass.model_name.human, I18n.t('activerecord.models.position.one')
    assert_equal klass.model_name.human(:count => 2), I18n.t('activerecord.models.position.other')

    #Associations
    assert_equal klass.human_attribute_name("contacts"), I18n.t('activerecord.models.contact.other')
  end

  test 'fields' do
    assert_respond_to subject, :name
  end

  ### ASSOCIATIONS ###
  should have_many(:contacts).inverse_of(:position)

  ### VALIDATIONS ###
  should validate_presence_of(:name)

end