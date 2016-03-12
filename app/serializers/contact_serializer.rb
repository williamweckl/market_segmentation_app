#encoding: UTF-8
class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :age, :state, :position

  def state
    {
        id: object.state,
        name: object.state_humanize
    }
  end

  def position
    {
        id: object.position_id,
        name: object.position.name
    }
  end

end
