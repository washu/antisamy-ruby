module AntiSamy
  class Scanner
    attr_accessor :policy, :errors, :nofollow, :pae
    DEFAULT_ENCODE = "UTF-8"
    ALLOW_EMPTY = %w[br hr a img link iframe script object applet frame base param meta input textarea embed basefont col]
    # Setup a basic param tag rule
    begin
      name_attr = Attribute.new("name")
      value_attr = Attribute.new("value")
      name_attr.expressions << /.*/
      value_attr.expressions << /.*/
      @@basic_param_tag_rule = Tag.new("param")
      @@basic_param_tag_rule << name_attr
      @@basic_param_tag_rule << value_attr
      @@basic_param_tag_rule.action = Policy::ACTION_VALIDATE
    end

    # Create a scanner with a given policy
    def initialize(policy)
      @policy = policy
      @errors = []
    end

    # Scan the input using the provided input and output encoding
    # will raise an error if nil input or the maximum input size is exceeded
    def scan(input, input_encode, output_encoder)
      raise ArgumentError if input.nil?
      raise ScanError, "Max input Exceeded #{input.size} > #{@policy.max_input}" if input.size > @policy.max_input
      # check poilcy stuff
      handler = Handler.new(@policy,output_encoder)
      scanner = SaxFilter.new(@policy,handler,@@basic_param_tag_rule)
      parser = Nokogiri::HTML::SAX::Parser.new(scanner,input_encode)
      #parser.parse(input)
      parser.parse(input) do |ctx|
        ctx.replace_entities = true
      end
      results = ScanResults.new(Time.now)
      results.clean_html = handler.document
      results.messages = handler.errors
      results
    end
  end
end
