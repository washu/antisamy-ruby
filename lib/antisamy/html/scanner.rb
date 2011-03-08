module AntiSamy

  class ScanError < StandardError; end

  # Scan message, it will contain a message key, tag and optionally content, value
  class ScanMessage
    # error.tag.notfound
    ERROR_TAG_NOT_IN_POLICY = "error.tag.notfound"
    # error.tag.removed
    ERROR_TAG_DISALLOWED = "error.tag.removed"
    # error.tag.filtered
    ERROR_TAG_FILTERED = "error.tag.filtered"
    # error.tag.encoded
    ERROR_TAG_ENCODED = "error.tag.encoded"
    # error.css.tag.malformed
    ERROR_CSS_TAG_MALFORMED = "error.css.tag.malformed"
    # error.css.attribute.malformed
    ERROR_CSS_ATTRIBUTE_MALFORMED = "error.css.attribute.malformed"
    # error.attribute.invalid.filtered
    ERROR_ATTRIBUTE_CAUSE_FILTER = "error.attribute.invalid.filtered"
    # error.attribute.invalid.encoded
    ERROR_ATTRIBUTE_CAUSE_ENCODE = "error.attribute.invalid.encoded"
    # error.attribute.invalid.filtered
    ERROR_ATTRIBUTE_INVALID_FILTERED = "error.attribute.invalid.filtered"
    # error.attribute.invalid.removed
    ERROR_ATTRIBUTE_INVALID_REMOVED = "error.attribute.invalid.removed"
    # error.attribute.notfound
    ERROR_ATTRIBUTE_NOT_IN_POLICY = "error.attribute.notfound"
    # error.attribute.invalid
    ERROR_ATTRIBUTE_INVALID = "error.attribute.invalid"

    attr_reader :tag, :content, :value, :msgkey
    def initialize(msgkey, tag, content=nil,value=nil)
      @msgkey = msgkey
      @tag = tag
      @content = content
      @value = value
    end
    def to_s
      "#{self.msgkey} #{@tag} #{@content} #{@value}"
    end
  end

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
      raise ScanError, "Max input Exceeded" if input.size > @policy.max_input
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
