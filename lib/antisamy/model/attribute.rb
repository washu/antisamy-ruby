module AntiSamy
  # A model for HTML attributes and the "rules" they must follow (either literals or regular expressions) in
  # order to be considered valid. This is a simple container class
  class Attribute
    attr_accessor :name, :description, :action, :values, :expressions
    ACTION_REMOVE_TAG = "removeTag"
    ACTION_FILTER_TAG = "filterTag"
    ACTION_ENCODE_TAG = "encodeTag"
    ACTION_REMOVE_ATTRIB = "removeAttribute"
    # Create a new attribute
    def initialize(name)
      @name = name
      @description = nil
      @action = nil
      @values = []
      @expressions = []
    end
  end
end
