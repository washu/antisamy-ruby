module AntiSamy
  # A model for CSS properties and the "rules" they must follow (either literals
  # or regular expressions) in order to be considered valid.
  class CssProperty
    attr_accessor :name, :description, :action, :values, :expressions, :refs, :catagories

    # Create a new property
    def initialize(name)
      @name = name
      @description = nil
      @values = []
      @expressions = []
      @refs = []
      @categories = []
      @action = nil
    end

    # Add a literal value to this property
    def add_value(value)
      @values << value
    end

    # Add a regular expression to this property
    def add_expression(exp)
      @expressions << exp
    end

    # Add a shorthand reference to this property
    def add_ref(ref)
      @refs << ref
    end

    # Add a category to this property
    def add_category(cat)
      @categories << cat
    end

  end
end
