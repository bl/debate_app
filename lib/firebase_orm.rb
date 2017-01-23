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

    def all
      response = client.get(firebase_class)
      resources = parsed_body(response.body)
      return [] unless resources && response.code.between?(200, 299)

      resources.map do |id, resource|
        self.new(resource.merge("id" => id))
      end
    end

    def search(owner_id = nil)
      return all unless owner_id

      response = client.get(associations_url(owner_id: owner_id))
      associations = parsed_body(response.body)
      return [] unless associations && response.code.between?(200, 299)

      associations.keys.map do |id|
        find(id)
      end
    end

    def find(id)
      response = client.get(resource_url(id))
      resource = parsed_body(response.body)
      return nil unless resource && response.code.between?(200, 299)

      self.new(resource.merge("id" => id))
    end

    def save(ids, attributes)
      attributes.except!(:id)
      request_type = ids[:id] ? "update" : "push"
      response = client.send(request_type, resource_url(ids[:id]), attributes)

      if ids.key?(:owner_id)
        new_resource_id = response.body["name"]
        ids.merge!(id: new_resource_id)
        response = client.set(associations_url(ids), true)
      end
      response && response.code == 201
    end

    def destroy(ids)
      response = client.delete(resource_url(ids[:id]))
      response = client.delete(associations_url(ids))
    end

    def belongs_to(owner)
      @owner ||= owner
    end

    private

    def associations_url(id: nil, owner_id: nil)
      association_name = ["#{@owner}", "#{firebase_class}"].compact.join('_')
      [association_name, owner_id, id].compact.join('/')
    end

    def resource_url(id = nil)
      [firebase_class, id].compact.join('/')
    end

    def firebase_class
      self.name.downcase.pluralize
    end

    def owner_class
      defined?(@owner) ? @owner : nil
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
end
