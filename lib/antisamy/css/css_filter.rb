module AntiSamy
  class CssFilter < RSAC::DocumentHandler
    
    attr_accessor :clean, :errors
    
    def initialize(policy,validator,tag)
      @policy = policy
      @validator = validator
      @errors = []
      @clean = ''
      @tag = tag
    end
    def start_document(input_source)
      puts "Starting document #{input_source}"
    end

    # Receive notification of the end of a style sheet.
    def end_document(input_source)
      puts "Ending document " #{input_source}"
    end

    # Receive notification of a comment
    def comment(text)
      puts "Got Comment #{text}"
    end

    # Receive notification of an unknown at rule not supported by this parser.
    def ignorable_at_rule(at_rule)
      puts "Ignorable rule #{at_rule}"
    end

    def namespace_declaration(prefix, uri)
      puts "NS Descl #{prefix} #{uri}"
    end

    # Called on an import statement
    def import_style(uri, media, default_namespace_uri = nil)
      puts "Import #{uri} #{media} #{default_namespace_uri}"
    end

    # Notification of the start of a media statement
    def start_media(media)
      puts "Start media #{media}"
    end

    # Notification of the end of a media statement
    def end_media(media)
      puts "End media #{media}"
    end

    # Notification of the start of a page statement
    def start_page(name = nil, pseudo_page = nil)
      puts "Start Page #{page} #{pseudo_page}"
    end

    # Notification of the end of a page statement
    def end_page(name = nil, pseudo_page = nil)
      puts "End Page #{page} #{pseudo_page}"
    end

    # Notification of the beginning of a font face statement.
    def start_font_face
      puts "Start font face"
    end

    # Notification of the end of a font face statement.
    def end_font_face
      puts "End font face"
    end

    # Notification of the beginning of a rule statement.
    def start_selector(selectors)
      puts "Starting selectors"
      selectors.each do |s|
        puts s.inspect
      end
    end

    # Notification of the end of a rule statement.
    def end_selector(selectors)
      puts "Ending selectors"
      selectors.each do |s|
        puts s.inspect
      end

    end

    # Notification of a declaration.
    def property(name, value, important)
      puts "Prperty #{name} #{important}"
      value.each do |v|
        puts "#{v.lexical_unit_type}, #{v.string_value}"
      end
    end
  end
end
