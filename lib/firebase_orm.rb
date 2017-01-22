module FirebaseORM
  attr_accessor :id, :owner_id

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def client
      conf = Settings.firebase
      @client ||= Firebase::Client.new(
        conf.uri,
        conf.secret
      )
    end

    def all(owner_id = nil)
      response = client.get(resource_url(owner_id: owner_id))
      resources = parsed_body(response.body)
      return [] unless resources && response.code.between?(200, 299)

      resources.map do |id, resource|
        self.new(resource.merge("id" => id))
      end
    end

    def find(id, owner_id = nil)
      ids = { id: id, owner_id: owner_id }
      response = client.get(resource_url(ids))
      resource = parsed_body(response.body)
      return nil unless resource && response.code.between?(200, 299)

      self.new(resource.merge("id" => id))
    end

    def save(ids, attributes)
      attributes.except!(:id)
      request_type = ids[:id] ? "update" : "push"
      response = client.send(request_type, resource_url(ids), attributes)
    end

    def destroy(ids)
      response = client.delete(resource_url(ids))
    end

    def belongs_to(owner)
      @owner ||= owner
    end

    #def belongs_to(owner)
      #klass = res_name.to_s.capitalize.constantize
      #define_method owner do
        #return "@#{owner}" unless defined?("@#{owner}")
        #resource = klass.find()
        #send("@#{owner}=", klass.find())
      #end
    #end

    #def has_many(resource)
      #return unless res_name = attributes.select { |attr| attr.pluralize == resource }
      #res_klass = res_name.capitalize.constantize
      #define_method resource do
        #return "@#{resource}" unless defined?("@#{resource}")
        #resources = []
        #send("@#{resource}||=", )
      #end
    #end

    private

    def resource_url(id: nil, owner_id: nil)
      [firebase_class, owner_id, id].compact.join('/')
    end

    def firebase_class
      self.name.downcase.pluralize
    end

    def parsed_body(body)
      case body
      when String
        JSON.parse(body)
      else
        body
      end
    end
  end

  def persisted?
    id.present?
  end

  def save
    generate_id
    self.class.save(ids, attributes)
  end

  def update(input_attributes)
    assign_attributes(input_attributes)
    self.class.save(ids, attributes)
  end

  def destroy
    self.class.destroy(ids)
  end

  private

  def ids
    attributes.slice(:id, :owner_id)
  end
  
  def generate_id
    self.id = SecureRandom.hex[0..20] unless id
  end
end
