module AntiSamy
  # A model for HTML "tags" and the rules dictating their validation/filtration. Also contains information
  # about their allowed attributes.
  class Tag
    # Name and Action fields. Actions determine what we do when we see this tag
    attr_accessor :name, :action

    # Create a new Tag object
    def initialize(name)
      @name = name
      @action = action
      @allowed_attributes = {}
    end

    # Add an attribute to this property
    def <<(attribute)
      @allowed_attributes[attribute.name.downcase] = attribute
    end

    # fetch the map of attributes
    def attributes
      @allowed_attributes
    end

    # Fetch a property by name form this tag
    def attribute(name)
      @allowed_attributes[name]
    end

  end
end
