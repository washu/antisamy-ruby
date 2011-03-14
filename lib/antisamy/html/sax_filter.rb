module AntiSamy
  # Quick and Dirty Stack class
  class Stack
    def initialize
      @stack = []
    end
    # push an emement ont he stack
    def push(v)
      @stack.push v
    end
    # pop an element off the stack
    def pop
      @stack.pop
    end
    # size of stack
    def size
      @stack.size
    end
    # is the stack empty
    def empty?
      @stack.empty?
    end
    # peek to see what next element is
    def peek?(v)
      return false if @stack.empty?
      return @stack.last.eql?(v)
    end

    def peek
      @stack.last
    end

  end

  class SaxFilter < Nokogiri::XML::SAX::Document
    def initialize(policy,handler,param_tag)
      @policy = policy
      @handler = handler
      @stack = Stack.new
      @css_content = nil
      @css_attributes = nil
      @css_scanner = CssScanner.new(policy)
      @param_tag = param_tag
    end

    def error(text)
    end

    def warning(text)
    end

    # Always create a HTML document unless the DECL was set beforehand
    def start_document
    end

    # Add a comment block
    def comment(text)
      return if text.nil?
      if @policy.directive(Policy::PRESERVE_COMMENTS) =~ /true/i
        # Strip out conditional directives
        text.gsub!(%r{<!?!\[(?:end)?if*\]}ixm,"")
        text.gsub!(%r{\[(?:if).*\]>},"")
        @handler.comment(text)
      end
    end

    def convert_array(x)
      if x and x.first.is_a?(Array)
        return x
      end
      i = 0
      h = []
      while i < x.size
        m = []
        m[0] = x[i]
        m[1] = x[i+1]
        h << m
        i += 2
      end
      h
    end

    def fetch_attribute(array,key)
      array.each do |pair|
        if pair.first.eql?(key)
          return pair.last
        end
      end
      nil
    end

    # Start an element,
    def start_element(name, attributes = [])
      attributes = convert_array(attributes)
      o_attributes = attributes.dup
      tag = @policy.tag(name)
      masquerade = false
      embed_name = nil
      embed_value = nil
      # Handle validate param tag as an embed tag
      if tag.nil? && @policy.directive(Policy::VALIDATE_P_AS_E) && name.eql?("param")
        embed = @param_tag
        if @policy.tag("embed")
          embed = @policy.tag("embed")
        end
        if embed and embed.action == Policy::ACTION_VALIDATE
          tag = embed
          masquerade = true
          embed_name = fetch_attribute(attributes,"name")
          embed_value = fetch_attribute(attributes,"value")
          attributes = [ [embed_name,embed_value] ]
        end
      end
      valid_attributes = []
      if @stack.peek?(:css) or @stack.peek?(:remove)
        # We are in remove mode to remove this tag as well as any child style elements if css mode
        @stack.push(:remove)
      elsif (tag.nil? && @policy.directive(Policy::ON_UNKNOWN_TAG).eql?("encode")) or (!tag.nil? && tag.action.eql?(Policy::ACTION_ENCODE)) or @policy.encode?(name.downcase)
        tmp = "<#{name}>"
        @handler.characters(tmp)
        @stack.push(:filter)
      elsif tag.nil?
        # We ignore missing HTML and BODY tags since we are fragment parsing, but the 
        # Nokogiri HTML::SAX parser injects HTML/BODY if they are missing
        unless name.eql?("html") or name.eql?("body")
          @handler.errors << ScanMessage.new(ScanMessage::ERROR_TAG_NOT_IN_POLICY,name)
        end
        # Nokogiri work around for a style tag being auto inserted inot head
        if name.eql?("head")
          @stack.push(:remove)
        else
          @stack.push(:filter)
        end
      elsif tag.action.eql?(Policy::ACTION_FILTER)
        @handler.errors << ScanMessage.new(ScanMessage::ERROR_TAG_FILTERED,name)
        @stack.push(:filter)
      elsif tag.action.eql?(Policy::ACTION_VALIDATE)
        # Handle validation
        remove_tag = false
        filter_tag = false
        is_style = name.include?("style")
        if is_style
          @stack.push(:css)
          @css_content = ''
          @css_attributes = []
        else
          # Validate attributes
          attributes.each do |pair|
            a_name = pair.first
            a_value = pair.last
            attrib = tag.attribute(a_name.downcase)
            if attrib.nil?
              attrib = @policy.global(a_name.downcase)
            end
            # check if the attribute is a style
            if a_name.eql?("style")
              # Handle Style tags
               begin
                 results = @css_scanner.scan_inline(a_value,name,@policy.max_input)
                 unless result.clean_html.empty?
                   valid_attributes << [a_name,results.clean_html]
                 end
                 @handler.errors << results.messages
                 @handler.errors.flatten!
               rescue Exception => e
                 @handler.errors << ScanMessage.new(ScanMessage::ERROR_CSS_ATTRIBUTE_MALFORMED,name,@handler.encode_text(a_value))
               end
            elsif !attrib.nil? # Attribute is not nil lets check it
              valid = false
              attrib.values.each do |av|
                if av.eql?(a_value)
                  valid_attributes << [a_name,a_value]
                  valid = true
                  break
                end
              end
              unless valid
                attrib.expressions.each do |ae|
                  mc = ae.match(a_value)
                  if mc and mc.to_s == a_value
                    valid_attributes << [a_name,a_value]
                    valid = true
                    break
                  end
                end
              end
              # we check the matches
              if !valid && attrib.action.eql?(Attribute::ACTION_REMOVE_TAG)
                @handler.errors << ScanMessage.new(ScanMessage::ERROR_ATTRIBUTE_INVALID_REMOVED,tag.name,@handler.encode_text(a_name),@handler.encode_text(a_value))
                remove_tag = true
              elsif !valid && attrib.action.eql?(Attribute::ACTION_FILTER_TAG)
                @handler.errors << ScanMessage.new(ScanMessage::ERROR_ATTRIBUTE_CAUSE_FILTER,tag.name,@handler.encode_text(a_name),@handler.encode_text(a_value))
                filter_tag = true
              elsif !valid
                @handler.errors << ScanMessage.new(ScanMessage::ERROR_ATTRIBUTE_INVALID,tag.name,@handler.encode_text(a_name),@handler.encode_text(a_value))
              end

            else # attribute was null
              @handler.errors << ScanMessage.new(ScanMessage::ERROR_ATTRIBUTE_NOT_IN_POLICY,tag.name,a_name,@handler.encode_text(a_value))
              if masquerade
                filter_tag = true
              end
            end
          end # end attirubte loop
        end
        if remove_tag
          @stack.push(:remove)
        elsif filter_tag
          @stack.push(:filter)
        else
          if name.eql?("a") and @policy.directive(Policy::ANCHROS_NOFOLLOW)
            valid_attributes << ["rel","nofollow"]
          end
          if masquerade
            valid_attributes = []
            valid_attributes << ["name",embed_name]
            valid_attributes << ["value",embed_value]
          end
          @stack.push(:keep) unless @stack.peek?(:css)
        end
        # End validation action
      elsif tag.action.eql?(Policy::ACTION_TRUNCATE)
        @stack.push(:truncate)
      else
        @handler.errors << ScanMessage.new(ScanMessage::ERROR_TAG_DISALLOWED,name)
        @stack.push(:remove)
      end
      # We now know wether to keep or truncat this tag
      if @stack.peek?(:truncate)
        @handler.start_element(name,[])
      elsif @stack.peek?(:keep)
        @handler.start_element(name,valid_attributes)
      end
    end

    def start_element_namespace(name,attrs=[],prefix = nil, uri = nil, ns = nil)
      start_element(name,attrs)
    end

    def end_element_namespace(name,prefix,uri)
      end_element(name)
    end

    # Add character data to the current tag
    def characters(text)
      unless text =~ /\S/ # skip whitespace
        return unless @policy.directive(Policy::PRESERVE_SPACE)
      end
      if @stack.peek?(:css)
        @css_content << text
      elsif !@stack.peek?(:remove)
        @handler.characters(text)
      end
    end

    # End an elements, will raise an error on a loose tag
    def end_element(name)
      if @stack.peek?(:remove)
        @stack.pop
      elsif @stack.peek?(:filter)
        @stack.pop
      elsif @stack.peek?(:css)
        @stack.pop
        # Do css stuff here
         begin
           results = @css_scanner.scan_sheet(@css_content,@policy.max_input)
           @handler.errors << results.messages
           @handler.errors.flatten!
           unless results.clean_html.nil? or results.clean_html.empty?
             @handler.start_element(name,@css_attributes)
             @handler.characters results.clean_html
             @handler.end_element(name)
           else
             @handler.start_element(name,@css_attributes)
             @handler.characters "/* */"
             @handler.end_element(name)             
           end
         rescue Exception => e
           puts e
           @handler.errors << ScanMessage.new(ScanMessage::ERROR_CSS_TAG_MALFORMED,name,@handler.encode_text(@css_content))
         ensure
           @css_content = nil
           @css_attributes = nil
         end
      else
        @stack.pop
        @handler.end_element(name)
      end
    end

    # Add cdata a cdata block
    def cdata_block(text)
      if @stack.peek?(:css)
        @css_content << text
      elsif !@stack.peek?(:remove)
        @handler.characters(text)
      else
        @handler.cdata(@handler.encode_text(text)) unless @stack.peek == :remove
      end
    end
  end
end
