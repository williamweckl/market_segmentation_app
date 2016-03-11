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
  validates_numericality_of :age, only_integer: true, less_than_or_equal_to: 16, greater_than_or_equal_to: 105

  #Callbacks
  before_validation {self.email.downcase! if email.present?}
end
