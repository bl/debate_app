class Topic
  include ActiveModel::Model
  include FirebaseORM

  attr_accessor :title, :description

  def attributes
    {
      id: id,
      title: title,
      description: description
    }
  end

  def initialize(attributes={})
    super
  end
end
