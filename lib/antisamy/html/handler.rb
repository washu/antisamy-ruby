module AntiSamy

  class Handler

    attr_accessor :errors
    def initialize(policy,output,fragment = true) #:nodoc:
      @document = Nokogiri::HTML::DocumentFragment.parse("")
      @current_node = @document
      @policy = policy
      @preserve_whitespace = @policy.directive(Policy::PRESERVE_SPACE)
      @errors = []
      @output_encoding = output
	  @fragment = fragment
    end

    # HTML entity encode some text
    def encode_text(text)
      return "" if text.nil?
      @document.encode_special_chars(text)
    end

    # create a cdata section
    def cdata(text)
      node = Nokogiri::XML::CDATA.new(@document,text)
      @current_node.add_child(node)
    end

    # create a comment
    def comment(text) #:nodoc:
      @current_node.add_child(Nokogiri::XML::Comment.new(@document, text))
    end

    # create a text node
    def characters(text)
      node = @current_node.children.last
      if node and node.text?
        node.content += text
      else
        @current_node.add_child(Nokogiri::XML::Text.new(text, @document))
      end
    end

    # start an element
    def start_element(name,attributes)
	  if @fragment
		if name.eql?("head") or name.eql?("body") or name.eql?("html")
			return
		end
	  end
      elem = Nokogiri::XML::Element.new(name, @document)
      attributes.each do |attrib_pair|
        elem[attrib_pair.first] = attrib_pair.last
      end
      # Special param tag hacking, as libxml/nokogiri doesnt generate an end tag
      # for param tags it seems
      if name.eql?("param")
        inner_html = "<param"
        attributes.each do |attrib_pair|
          inner_html<< " #{attrib_pair.first}=\"#{attrib_pair.last}\""
        end
        inner_html << "/>"
        # we create a fake cdata node, add it *and* dont move our parent yet
        elem = Nokogiri::XML::CDATA.new(@document,inner_html)
        @current_node.add_child(elem)
        return
      end
      @current_node = @current_node.add_child(elem)
    end

    #end an element
    def end_element(name)
      if @current_node.nil? or !@current_node.name.eql?(name)
        return
      end
	  if @current_node.children.empty?
		if @policy.allow_empty?(@current_node.name)
			@current_node = @current_node.parent if @current_node.parent
		else
			tnode = @current_node
			@current_node = @current_node.parent if @current_node.parent
			tnode.remove
		end
	  else
		@current_node = @current_node.parent if @current_node.parent
	  end
    end

    # format the output applying any policy rules
    def document
      # check some directives
      indent = 0
      options = Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS
      if @policy.directive(Policy::FORMAT_OUTPUT)
        options |= Nokogiri::XML::Node::SaveOptions::FORMAT
        indent = 2
      end
      if @policy.directive(Policy::OMIT_DOC_TYPE) || @policy.directive(Policy::OMIT_XML_DECL)
        options |= Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
      end

      clean = ""
      if @policy.directive(Policy::USE_XHTML)
        options |= Nokogiri::XML::Node::SaveOptions::AS_XHTML
        clean = @document.to_xhtml(:encoding => @output_encoding, :indent=>indent,:save_with=>options)
      else
        clean = @document.to_html(:encoding => @output_encoding, :indent=>indent,:save_with=>options)
      end
      return clean
    end

  end
end
