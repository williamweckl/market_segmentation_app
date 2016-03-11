module ModelTestHelpers
  def should_require(association)
    subject.send("#{association}=", nil)
    subject.valid?
    assert_includes subject.errors[association], I18n.t('errors.messages.required')
  end
  def should_have_valid(field, correct_id, error_field, message = :required)
    message = I18n.t("errors.messages.#{message}")

    subject.send("#{field}=", 9999)
    subject.valid?
    assert_includes subject.errors[error_field], message

    subject.send("#{field}=", correct_id)
    subject.valid?
    assert_not_includes subject.errors[error_field], message
  end
  def should_have_valid_association(field, correct_id, error_field)
    should_have_valid(field, correct_id, error_field)
  end
  def should_have_valid_enum(field, correct_id, error_field)
    should_have_valid(field, correct_id, error_field, :inclusion)
  end
end