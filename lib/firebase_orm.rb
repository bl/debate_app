module FirebaseORM
  attr_accessor :id

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

    def find(id)
      response = client.get("#{firebase_class}/#{id}")
      resource = parsed_body(response.body)
      return nil unless resource && response.code.between?(200, 299)

      self.new(resource.merge("id" => id))
    end

    def save(id, attributes)
      attributes.except!(:id)
      response = client.update("#{firebase_class}/#{id}", attributes)
    end

    def destroy(id)
      response = client.delete("#{firebase_class}/#{id}")
    end

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
    self.class.save(id, attributes)
  end

  def update(input_attributes)
    assign_attributes(input_attributes)
    self.class.save(id, attributes)
  end

  def destroy
    self.class.destroy(id)
  end
end
