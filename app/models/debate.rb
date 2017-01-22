class Debate
  include ActiveModel::Model
  include FirebaseORM

  attr_accessor :status
  
  def topic
    @topic ||= Topic.find(id)
  end

  #has_many :topics

  def attributes
    {
      id: id,
      status: status
    }
  end
end
