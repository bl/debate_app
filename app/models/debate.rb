class Debate
  include ActiveModel::Model
  include FirebaseORM

  attr_accessor :topic, :status

  belongs_to :topic
  
  #def topic
    #@topic ||= Topic.find(id)
  #end

  #has_many :topics

  def attributes
    {
      id: id,
      owner_id: owner_id,
      status: status
    }
  end
end
