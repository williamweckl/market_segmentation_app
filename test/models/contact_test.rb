require 'test_helper'
class ContactTest < ActiveSupport::TestCase

  include ModelTestHelpers

  subject { contacts(:one) }
  let(:klass) { subject.class }

  # create_table :contacts do |t|
  #   t.string :name, null: false
  #   t.string :email, null: false
  #   t.integer :age, null: false
  #   t.integer :state, null: false, index: true
  #   t.references :position, foreign_key: true, null: false
  #
  #   t.timestamps
  # end

  test 'translations' do
    #Attributes
    assert_equal klass.human_attribute_name("name"), I18n.t('attributes.name')
    assert_equal klass.human_attribute_name("created_at"), I18n.t('attributes.created_at')
    assert_equal klass.human_attribute_name("updated_at"), I18n.t('attributes.updated_at')

    assert_equal klass.human_attribute_name("email"), I18n.t('activerecord.attributes.contact.email')
    assert_equal klass.human_attribute_name("age"), I18n.t('activerecord.attributes.contact.age')
    assert_equal klass.human_attribute_name("state"), I18n.t('activerecord.attributes.contact.state')

    #Model name
    assert_equal klass.model_name.human, I18n.t('activerecord.models.contact.one')
    assert_equal klass.model_name.human(:count => 2), I18n.t('activerecord.models.contact.other')

    #Associations
    assert_equal klass.human_attribute_name("position"), I18n.t('activerecord.models.position.one')
    assert_equal klass.human_attribute_name("position_id"), I18n.t('activerecord.models.position.one')
  end

  test 'indexes' do
    foreign_keys = ActiveRecord::Base.connection.foreign_keys(klass.table_name).map { |fk| {to_table: fk["to_table"], fk: fk["options"][:column]} }
    assert_includes foreign_keys, {:to_table => "positions", :fk => "position_id"}

    assert_equal ActiveRecord::Base.connection.index_exists?(klass.table_name.to_sym, :state), true
    assert_equal ActiveRecord::Base.connection.index_exists?(klass.table_name.to_sym, :position_id), true
  end

  test 'fields' do
    assert_respond_to subject, :name
    assert_respond_to subject, :email
    assert_respond_to subject, :age
    assert_respond_to subject, :state
  end

  ### ASSOCIATIONS ###
  should belong_to(:position).inverse_of(:contacts)

  ### VALIDATIONS ###
  should validate_presence_of(:name)
  should validate_presence_of(:email)
  should validate_presence_of(:age)
  should validate_presence_of(:state)
  should validate_numericality_of(:age).only_integer.is_greater_than_or_equal_to(16).is_less_than_or_equal_to(105)

  test 'position should be required' do
    should_require(:position)
  end

  test 'valid associations' do
    should_have_valid_association(:position_id, positions(:one).id, :position)
    should_have_valid_enum(:state, State::SC, :state)
  end

  test 'valid email' do
    subject.email = 'foo@bar+baz.com'
    subject.valid?
    assert_includes subject.errors[:email], I18n.t('errors.messages.invalid')

    subject.email = 'string'
    subject.valid?
    assert_includes subject.errors[:email], I18n.t('errors.messages.invalid')

    subject.email = 'EMAIL@EMAIL.COM'
    subject.valid?
    assert_equal subject.email, 'email@email.com'
    assert_not_includes subject.errors[:email], I18n.t('errors.messages.invalid')

    subject.email = 'foo@bar.com'
    subject.valid?
    assert_not_includes subject.errors[:email], I18n.t('errors.messages.invalid')
  end

end
