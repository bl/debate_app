class Message
  include ActiveModel::Model
  include FirebaseORM

  attr_accessor :body

  belongs_to :debate

  def attributes
    {
      id: id,
      owner_id: owner_id,
      body: body
    }
  end
end
