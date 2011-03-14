require 'uri'
module AntiSamy
  class CssFilter < RSAC::DocumentHandler
    
    attr_accessor :clean, :errors
    
    def initialize(policy,tag)
      @policy = policy
      @validator = CssValidator.new(@policy)
      @errors = []
      @clean = ''
      @tag = tag
      @selector_open = false
      @sytle_sheets = []
      @inline = !tag.nil?
      @media_open = false
      @current_media = nil
    end
    # Start of document
    def start_document(input_source) #:nodoc:
    end

    # Receive notification of the end of a style sheet.
    def end_document(input_source) #:nodoc:
    end

    # Receive notification of a comment
    def comment(text)
      @errors << ScanMessage.new(ScanMessage::ERROR_COMMENT_REMOVED,@tag,text)
    end

    # Receive notification of an unknown at rule not supported by this parser.
    def ignorable_at_rule(at_rule)
      if inline
        @errors << ScanMessage.new(ScanMessage::ERROR_CSS_TAG_RULE_NOTFOUND,@tag,at_rule)
      else
        @errors << ScanMessage.new(ScanMessage::ERROR_STYLESHEET_RULE_NOTFOUND,@tag,at_rule)
      end
    end
    
    # Namespace declaration
    def namespace_declaration(prefix, uri) #:nodoc:
    end

    # Called on an import statement
    def import_style(uri, media, default_namespace_uri = nil)
      # check directive
      unless @policy.directive("embedStyleSheets")
        @errors << ScanMessage.new(ScanMessage::ERROR_STYLESHEET_RULE_NOTFOUND,@tag,uri)
      end
      # check for null uri
      if uri.nil?
        @errors << ScanMessage.new(ScanMessage::ERROR_CSS_IMPORT_URL_INVALID,@tag)
      end
      # check uri rules
      begin
        link = URI.parse(uri)
        link.normalize!
        onsite = @policy.expression("offsiteURL")
        offsite = @policy.expression("onsiteURL")
        # bad uri
        raise "Invalid URI Pattern" if link.to_s !~ onsite and link.to_s !~ offsite
        raise "Invalid URI" unless link.absolute?
        @style_sheets << link
      rescue Exception => e
        @errors << ScanMessage.new(ScanMessage::ERROR_CSS_IMPORT_URL_INVALID,@tag,uri)        
      end
    end

    # Notification of the start of a media statement
    def start_media(media)
      @media_open = true
      @current_media = media
    end

    # Notification of the end of a media statement
    def end_media(media)
      @media_open = false
      @current_media = nil
    end

    # Notification of the start of a page statement
    def start_page(name = nil, pseudo_page = nil) #:nodoc:
    end

    # Notification of the end of a page statement
    def end_page(name = nil, pseudo_page = nil) # :nodoc:
    end

    # Notification of the beginning of a font face statement.
    def start_font_face #:nodoc:
    end

    # Notification of the end of a font face statement.
    def end_font_face #:nodoc:
    end

    # Notification of the beginning of a rule statement.
    def start_selector(selectors)
      count = 0
      selectors.each do |s|
        name = s.to_css
        valid = false
        begin
          @validator.valid_selector?(name,s)
        rescue Exception => e
          if @inline
            @errors << ScanMessage.new(ScanMessage::ERROR_CSS_TAG_SELECTOR_NOTFOUND,@tag,name)
          else
            @errors << ScanMessage.new(ScanMessage::ERROR_STYLESHEET_SELECTOR_NOTFOUND,@tag,name)
          end
        
        end
        if valid
          if count > 0
            clean << ", "
          end
          clean << name
          count += 1
        else
          # not allowed selector
          if @inline
            @errors << ScanMessage.new(ScanMessage::ERROR_CSS_IMPORT_URL_INVALID,@tag,name)
          else
            @errors << ScanMessage.new(ScanMessage::ERROR_STYLESHEET_SELECTOR_NOTFOUND,@tag,name)
          end
        end
      end
      if count > 0
        clean << " {\n"
        @selector_open = true
      end
    end

    # Notification of the end of a rule statement.
    def end_selector(selectors)
      if @selector_open
        clean << "}\n"
      end
      @selector_open = false
    end

    # Notification of a declaration.
    def property(name, value, important)      
      return unless @selector_open and @inline
      if @validator.valid_property?(name,value)
        clean << "\t" unless @inline
        clean << "#{name}:"
        value.each do |v|
          clean << " #{v.to_s}"
        end
        clean << ";"
        clean << "\n" unless @inline
      else
        cval = value.to_s
        if @inline
          @errors << ScanMessage.new(ScanMessage::ERROR_CSS_TAG_PROPERTY_INVALID,@tag,name,cval)
        else
          @errors << ScanMessage.new(ScanMessage::ERROR_STYLESHEET_PROPERTY_INVALID,@tag,name,cval)
        end        
      end
      
    end
  end
end
