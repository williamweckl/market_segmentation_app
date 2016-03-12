#encoding: UTF-8
class Contact < ApplicationRecord
  extend EnumerateIt

  #Enumeration
  has_enumeration_for :state

  #Associations
  belongs_to :position, inverse_of: :contacts

  #Validations
  validates_presence_of :name, :email, :age, :state
  validates :email, email: true
  validates :age, numericality: {only_integer: true, greater_than_or_equal_to: 16, less_than_or_equal_to: 105}

  #Callbacks
  before_validation {self.email.downcase! if email.present?}

  #Scopes
  scope :by_position_ids, -> (position_ids) { where(position_id: position_ids) }
  scope :by_age, -> (age) { where(age: age) }
  scope :by_age_range, -> (start_age, end_age) do
    if start_age and end_age
      where('age > ? and age < ?', start_age, end_age)
    elsif start_age
      where('age > ?', start_age)
    elsif end_age
      where('age < ?', end_age)
    end
  end
end
