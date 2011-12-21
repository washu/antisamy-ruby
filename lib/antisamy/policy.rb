require 'stringio'

module AntiSamy

  # Schema validation Error
  class SchemaError < StandardError; end
  # Policy validation error
  class PolicyError < StandardError; end

  # Model for our policy engine.
  # the XSD for AntiSammy is stored in this file after the END section
  class Policy
    attr_accessor :max_input
    # We allow these tags to be empty
    ALLOWED_EMPTY = ["br", "hr", "a", "img", "link", "iframe", "script", "object", "applet", "frame", "base", "param", "meta", "input", "textarea", "embed", "basefont", "col"]
    # *Actions*
    ACTION_FILTER = "filter"
    ACTION_TRUNCATE = "truncate"
    ACTION_VALIDATE = "validate"
    ACTION_REMOVE = "remove"
    ACTION_ENCODE = "encode"
    # Anything regular express
    ANYTHING_REGEX = /.*/
    # AntiSammy XSD constants
    DEFAULT_ONINVALID = "removeAttribute"
    # Directive Name Constants
    OMIT_XML_DECL = "omitXmlDeclaration"
    OMIT_DOC_TYPE = "omitDoctypeDeclaration"
    MAX_INPUT = "maxInputSize"
    USE_XHTML = "userXHTML"
    FORMAT_OUTPUT = "formatOutput"
    # will we allow embedded style sheets
    EMBED_STYLESHEETS = "embedStyleSheets"
    # Connection timeout in miliseconds
    CONN_TIMEOUT = "conenctionTimeout"
    ANCHORS_NOFOLLOW = "nofollowAnchors"
    VALIDATE_P_AS_E = "validateParamAsEmbed"
    PRESERVE_SPACE = "preserveSpace"
    PRESERVE_COMMENTS = "preserveComments"
    ON_UNKNOWN_TAG = "onUnknownTag"
    MAX_SHEETS = "maxStyleSheetImports"

    # Class method to fetch the schema
    def self.schema
      data = StringIO.new
      File.open(__FILE__) do |f|
        begin
          line = f.gets
        end until line.match(/^__END__$/)
        while line = f.gets
          data << line
        end
      end
      data.rewind
      data.read
    end

    # Create a policy object.
    # You can pass in either:
    # * File path
    # * IO object
    # * String containing the policy XML
    # All policies will be validated against the builtin schema file and will raise
    # an Error if the policy doesnt conform to the schema
    def initialize(string_or_io)
      schema = Nokogiri::XML.Schema(Policy.schema)
      if string_or_io.respond_to?(:read)
        uri = string_or_io.read
      else
        if File.exists?(string_or_io)
          uri = IO.read(string_or_io)
        else
          uri = string_or_io
        end
      end
      doc = Nokogiri::XML.parse(uri)
      # We now have the Poolicy XML data lets parse it
      errors = schema.validate(doc)
      raise SchemaError, errors.join(",") if errors.size > 0
      @common_regex = {}
      @common_attrib = {}
      @tag_rules = {}
      @css_rules = {}
      @directives = Hash.new(false)
      @global_attrib = {}
      @encode_tags = []
	  @allowed_empty = []
	  @allowed_empty << ALLOWED_EMPTY
	  @allowed_empty.flatten!
      parse(doc)
    end

    # Get a particular directive
    def directive(name)
      @directives[name]
    end

    # Set a directive for the policy
    def []=(name,value)
      @directives[name] = value
    end

    # Get a global attribute
    def global(name)
      @global_attrib[name.downcase]
    end

    # Is the tag in the encode list
    def encode?(tag)
      @encode_tags.include?(tag)
    end

    # Return the tag rules
    def tags
      @tag_rules
    end

    # get a specific tag
    def tag(name)
      @tag_rules[name.downcase]
    end

    # return the css rules
    def properties
      @css_rules
    end

    # get a specific css rule
    def property(prop)
      @css_rules[prop.downcase]
    end

    # Get the list of attributes
    def attributes
      @common_attrib
    end

    # Get a specific attribute
    def attribute(name)
      @common_attrib[name.downcase]
    end

    # Get the list of expressions
    def expressions
      @common_regex
    end

    # Get a specific expression
    def expression(name)
      @common_regex[name]
    end
	
	def allow_empty?(name)
		@allowed_empty.include?(name.downcase)
	end
	
    private
    def make_re(p,context) #:nodoc:
      output = StringIO.open('','w')
      $stderr = output
      begin
        r = /#{p}/
        warning = output.string
        raise PolicyError, "context=#{context}, error=#{$1}, re=#{p}",caller(2) if warning =~ /warning: (.*)$/
        return r
      rescue RegexpError => e
        raise PolicyError, "context=#{context}, error=#{e.message} re=#{p}", caller(2)
      ensure
        $stderr = STDERR
      end
    end

    # Parse the Policy file
    def parse(node) # :nodoc:
      if node.children.nil? or node.children.last.nil?
        return
      end
      node.children.last.children.each do |section|
        if section.name.eql?("directives")
          process_directves(section)
        elsif section.name.eql?("common-regexps")
          process_common_regexps(section)
        elsif section.name.eql?("common-attributes")
          process_common_attributes(section)
        elsif section.name.eql?("global-tag-attributes")
          process_global_attributes(section)
        elsif section.name.eql?("tags-to-encode")
          process_tag_to_encode(section)
        elsif section.name.eql?("tag-rules")
          process_tag_rules(section)
        elsif section.name.eql?("css-rules")
          process_css_rules(section)
		elsif section.name.eql?("allowed-empty-tags")
		  process_empty_tags(section)
        end
      end
    end

	def process_empty_tags(section)# :nodoc:
		# skip if we had no  section
		return if section.element_children.nil?
		section.element_children.each do |dir|
			if dir.name.eql?("literal-list")
				if dir.element_children
					dir.element_children.each do |child|
						tag = child["value"]
						if tag and !tag.empty?
							@allowed_empty << tag.downcase
						end
					end
				end
			end
		end
	end
    # process the directives section
    def process_directves(section) # :nodoc:
      # skip if we had no  section
      return if section.element_children.nil?
      # process the rules
      section.element_children.each do |dir|
        name = dir["name"]
        value = dir["value"]
        if name.eql?("maxInputSize") 
          @max_input = value.to_i
        else
          if name.eql?("connectionTimeout") or name.eql?("maxStyleSheetImports")
            value = value.to_i
          elsif value =~ /true/i
            value = true
          else
            value = false
          end
          @directives[name] = value
        end
      end
    end

    # process the <common-regexp> section
    def process_common_regexps(section) # :nodoc:
      # skip if we had no section
      return if section.element_children.nil?
      section.element_children.each do |re|
        @common_regex[re["name"]] = make_re(re["value"],"common-regex(#{re['name']})")
      end
    end

    # Helper method to process a literal and regex section
    def process_attr_lists(att,node,exception) # :nodoc:
      node.element_children.each do |el|
        if el.name.eql?("regexp-list")
          if el.element_children
            el.element_children.each do |re|
              v = re["value"]
              n = re["name"]
              if n and !n.empty?
                if @common_regex[n].nil?
                  raise PolicyError, "regex #{n} in #{exception} but wasnt found in <common-regex>"
                else
                  att.expressions << expression(n)
                end
              else
                att.expressions << make_re(v,exception)
              end
            end
          end
        elsif el.name.eql?("literal-list")
          if el.element_children
            el.element_children.each do |re|
              v = re["value"]
              if v and !v.empty?
                att.values << v
              else
                if re.child and re.child.text?
                  att.values << re.child.content
                end
              end
            end
          end
        end
      end
    end

    # Process the <common-attributes> section
    def process_common_attributes(section) # :nodoc:
      # skip if we had no section
      return if section.element_children.nil?
      section.element_children.each do |val|
        invalid = val["onInvalid"]
        name = val["name"]
        desc = val["description"]
        att = Attribute.new(name)
        att.description = desc
        att.action = (invalid.nil? or invalid.empty?) ? DEFAULT_ONINVALID : invalid
        return if val.element_children.nil?
        process_attr_lists(att,val,"common-attribute(#{name})")
        @common_attrib[name.downcase] = att
      end
    end

    # Process the <global-attributes> section
    def process_global_attributes(section) # :nodoc:
      # skip if we had no section
      return if section.element_children.nil?
      section.element_children.each do |ga|
        name = ga["name"]
        att = @common_attrib[name]
        raise PolicyError, "global attribute #{name} was not defined in <common-attributes>" if att.nil?
        @global_attrib[name.downcase] = att
      end
    end

    # process the <tag-to-encode> section
    def process_tag_to_encode(section) # :nodoc:
      # skip if we had no section
      return if section.element_children.nil?
      section.element_children.each do |tag|
        if tag.child and  tag.child.text?
          @encode_tags << tag.child.content.downcase
        end
      end
    end

    # Process the <tag-ruls> section
    def process_tag_rules(section) # :nodoc:
      return if section.element_children.nil?
      section.element_children.each do |tx|
        name = tx["name"]
        action = tx["action"]
        t = Tag.new(name)
        t.action = action
        # Add attributes
        if tx.element_children
          tx.element_children.each do |tc|
            catt = @common_attrib[tc["name"]]
            if catt # common attrib with value override
              act = tc["onInvalid"]
              dec = tc["description"]
              ncatt = catt.dup
              ncatt.action = act unless act.nil? or act.empty?
              ncatt.description = dec unless dec.nil? or dec.empty?
              t<< ncatt
            else
              att = Attribute.new(tc["name"])
              att.action = tc["onInvalid"]
              att.description = tc["description"]
              process_attr_lists(att,tc," tag-rules(#{name})")
              t<< att
            end
          end
        end
        # End add attributes
        @tag_rules[name.downcase] = t
      end
    end

    # Process the <css-rules> section
    def process_css_rules(section) # :nodoc:
      return if section.element_children.nil?
      section.element_children.each do |css|
        name = css["name"]
        desc = css["description"]
        action = css["onInvalid"]
        if action.nil? or action.empty?
          action = DEFAULT_ONINVALID
        end
        prop = CssProperty.new(name)
        prop.action = action
        prop.description = desc
        # Process regex, listerals and shorthands
        if css.element_children
          css.element_children.each do |child|
            empty = child.element_children.nil?
            # Regex
            if child.name.eql?("regexp-list")
              unless empty
                child.element_children.each do |re|
                  re_name = re["name"]
                  re_value = re["value"]
                  gre = expression(re_name)
                  if gre
                    prop.add_expression(gre)
                  elsif re_value and !re_value.empty?
                    prop.add_expression(make_re(re_value,"css-rule(#{name})"))
                  else
                    raise PolicyError, "#{re_name} was referenced in CSS rule #{name} but wasnt found in <common-regexp>"
                  end
                end
              end
            elsif child.name.eql?("literal-list")   # literals
              unless empty
                child.element_children.each do |li|
                  prop.add_value(li["value"]) if li["value"]
                end
              end
            elsif child.name.eql?("category-list")   # literals
              unless empty
                child.element_children.each do |li|
                  prop.add_category(li["value"]) if li["value"]
                end
              end

            elsif child.name.eql?("shorthand-list")   # refs
              unless empty
                child.element_children.each do |sl|
                  prop.add_ref(sl["name"]) if sl["name"]
                end
              end
            end
          end
        end
        @css_rules[name.downcase] = prop
      end
    end
  end
end


__END__
<?xml version="1.0" encoding="UTF-8"?>
<xsd:schema
  xmlns:xsd="http://www.w3.org/2001/XMLSchema">
	<xsd:element name="anti-samy-rules">
		<xsd:complexType>
		<xsd:sequence>
			<xsd:element name="directives" type="Directives" maxOccurs="1" minOccurs="1"/>
			<xsd:element name="common-regexps" type="CommonRegexps" maxOccurs="1" minOccurs="1"/>
			<xsd:element name="common-attributes" type="AttributeList" maxOccurs="1" minOccurs="1"/>
			<xsd:element name="global-tag-attributes" type="AttributeList" maxOccurs="1" minOccurs="1"/>
			<xsd:element name="tags-to-encode" type="TagsToEncodeList" minOccurs="0" maxOccurs="1"/>
			<xsd:element name="tag-rules" type="TagRules" minOccurs="1" maxOccurs="1"/>
			<xsd:element name="css-rules" type="CSSRules" minOccurs="1" maxOccurs="1"/>
			<xsd:element name="allowed-empty-tags" type="AllowedEmptyTags" minOccurs="0" maxOccurs="1"/>
		</xsd:sequence>
		</xsd:complexType>
	</xsd:element>
	<xsd:complexType name="Directives">
		<xsd:sequence maxOccurs="unbounded">
			<xsd:element name="directive" type="Directive" minOccurs="0"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="Directive">
		<xsd:attribute name="name" use="required">
		<xsd:simpleType>
      <xsd:restriction base="xsd:string">
        <xsd:enumeration value="omitXmlDeclaration"/>
        <xsd:enumeration value="omitDoctypeDeclaration"/>
        <xsd:enumeration value="maxInputSize"/>
        <xsd:enumeration value="useXHTML"/>
        <xsd:enumeration value="embedStyleSheets"/>
        <xsd:enumeration value="maxStyleSheetImports"/>
        <xsd:enumeration value="connectionTimeout"/>
        <xsd:enumeration value="nofollowAnchors"/>
        <xsd:enumeration value="validateParamAsEmbed"/>
        <xsd:enumeration value="preserveComments"/>
        <xsd:enumeration value="preserveSpace"/>
        <xsd:enumeration value="onUnknownTag"/>
        <xsd:enumeration value="formatOutput"/>
      </xsd:restriction>
    </xsd:simpleType>
		</xsd:attribute>
		<xsd:attribute name="value" use="required"/>
	</xsd:complexType>
	<xsd:complexType name="CommonRegexps">
		<xsd:sequence maxOccurs="unbounded">
			<xsd:element name="regexp" type="RegExp" minOccurs="0"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="AttributeList">
		<xsd:sequence maxOccurs="unbounded">
			<xsd:element name="attribute" type="Attribute" minOccurs="0"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="TagsToEncodeList">
		<xsd:sequence maxOccurs="unbounded">
			<xsd:element name="tag" minOccurs="0"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="TagRules">
		<xsd:sequence maxOccurs="unbounded">
			<xsd:element name="tag" type="Tag" minOccurs="0"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="Tag">
		<xsd:sequence maxOccurs="unbounded">
			<xsd:element name="attribute" type="Attribute" minOccurs="0" />
		</xsd:sequence>
		<xsd:attribute name="name" use="required"/>
		<xsd:attribute name="action" use="required">
		  <xsd:simpleType>
			<xsd:restriction base="xsd:string">
				<xsd:enumeration value="validate"/>
				<xsd:enumeration value="truncate"/>
				<xsd:enumeration value="remove"/>
				<xsd:enumeration value="filter"/>
				<xsd:enumeration value="encode"/>
			</xsd:restriction>
		  </xsd:simpleType>
		</xsd:attribute>
	</xsd:complexType>
	<xsd:complexType name="Attribute">
		<xsd:sequence>
			<xsd:element name="regexp-list" type="RegexpList" minOccurs="0"/>
			<xsd:element name="literal-list" type="LiteralList" minOccurs="0"/>
		</xsd:sequence>
		<xsd:attribute name="name" use="required"/>
		<xsd:attribute name="description"/>
		<xsd:attribute name="onInvalid">
		  <xsd:simpleType>
        <xsd:restriction base="xsd:string">
          <xsd:enumeration value="removeTag"/>
          <xsd:enumeration value="filterTag"/>
          <xsd:enumeration value="encodeTag"/>
          <xsd:enumeration value="removeAttribute"/>
        </xsd:restriction>
      </xsd:simpleType>
		</xsd:attribute>
	</xsd:complexType>
	<xsd:complexType name="RegexpList">
		<xsd:sequence maxOccurs="unbounded">
			<xsd:element name="regexp" type="RegExp" minOccurs="0"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="RegExp">
		<xsd:attribute name="name" type="xsd:string"/>
		<xsd:attribute name="value" type="xsd:string"/>
	</xsd:complexType>
	<xsd:complexType name="LiteralList">
		<xsd:sequence maxOccurs="unbounded">
			<xsd:element name="literal" type="Literal" minOccurs="0"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="Literal">
		<xsd:attribute name="value" type="xsd:string"/>
	</xsd:complexType>
	<xsd:complexType name="CSSRules">
		<xsd:sequence maxOccurs="unbounded">
			<xsd:element name="property" type="Property" minOccurs="0"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="Property">
		<xsd:sequence>
			<xsd:element name="category-list" type="CategoryList" minOccurs="0"/>
			<xsd:element name="literal-list" type="LiteralList" minOccurs="0"/>
			<xsd:element name="regexp-list" type="RegexpList" minOccurs="0"/>
			<xsd:element name="shorthand-list" type="ShorthandList" minOccurs="0"/>
		</xsd:sequence>
		<xsd:attribute name="name" type="xsd:string" use="required"/>
		<xsd:attribute name="default" type="xsd:string"/>
		<xsd:attribute name="description" type="xsd:string"/>
	</xsd:complexType>
	<xsd:complexType name="ShorthandList">
		<xsd:sequence maxOccurs="unbounded">
			<xsd:element name="shorthand" type="Shorthand" minOccurs="0"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="Shorthand">
		<xsd:attribute name="name" type="xsd:string" use="required"/>
	</xsd:complexType>
	<xsd:complexType name="CategoryList">
		<xsd:sequence maxOccurs="unbounded">
			<xsd:element name="category" type="Category" minOccurs="0"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="Category">
		<xsd:attribute name="value" type="xsd:string" use="required"/>
	</xsd:complexType>
	<xsd:complexType name="Entity">
		<xsd:attribute name="name" type="xsd:string" use="required"/>
		<xsd:attribute name="cdata" type="xsd:string" use="required"/>
	</xsd:complexType>
	<xsd:complexType name="AllowedEmptyTags">
        <xsd:sequence>
            <xsd:element name="literal-list" type="LiteralList" minOccurs="1"/>
        </xsd:sequence>
    </xsd:complexType>

</xsd:schema>
