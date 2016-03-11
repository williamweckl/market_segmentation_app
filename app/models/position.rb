#encoding: UTF-8
class Position < ApplicationRecord
  #Associations
  has_many :contacts, inverse_of: :position

  #Validations
  validates_presence_of :name
end
