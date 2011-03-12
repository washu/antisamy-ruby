require "antisamy/csspool/rsac/sac/document_handler"
require "antisamy/csspool/rsac/sac/error_handler"
require "antisamy/csspool/rsac/sac/generated_parser"
require "antisamy/csspool/rsac/sac/lexical_unit"
require "antisamy/csspool/rsac/sac/parse_exception"
require "antisamy/csspool/rsac/sac/tokenizer"
require "antisamy/csspool/rsac/sac/property_parser"

module RSAC
  class Parser < RSAC::GeneratedParser
    # The version of CSSPool you're using
    VERSION = '0.2.7'

    TOKENIZER = Tokenizer.new

    attr_accessor :document_handler, :error_handler, :logger

    def initialize(document_handler = StyleSheet.new(self))
      @error_handler = ErrorHandler.new
      @document_handler = document_handler
      @property_parser = PropertyParser.new()
      @tokenizer = TOKENIZER
      @logger = nil
    end

    def parse_style_sheet(string)
      @yydebug = true
      @tokens = TOKENIZER.tokenize(string)
      @position = 0

      self.document_handler.start_document(string)
      do_parse
      self.document_handler.end_document(string)
      self.document_handler
    end

    alias :parse :parse_style_sheet

    def parse_rule(rule)
      returner = Class.new(DocumentHandler) {
        attr_accessor :selector
        alias :start_selector :selector=
      }.new
      old_document_handler = self.document_handler
      self.document_handler = returner
      self.parse("#{rule} { }")
      self.document_handler = old_document_handler
      returner.selector
    end

    # Returns the parser version.  We return CSS2, but its actually
    # CSS2.1.  No font-face tags.  Sorry.
    def parser_version
      "http://www.w3.org/TR/REC-CSS2"
    end

    attr_reader :property_parser
    attr_reader :tokenizer

    private # Bro.

    # We have to eliminate matching pairs.
    # http://www.w3.org/TR/CSS21/syndata.html#parsing-errors
    # See the malformed declarations section
    def eliminate_pair_matches(error_value)
      pairs = {}
      pairs['"'] = '"'
      pairs["'"] = "'"
        pairs['{'] = '}'
        pairs['['] = ']'
        pairs['('] = ')'

        error_value.strip!
        if pairs[error_value]
          logger.warn("Eliminating pair for: #{error_value}") if logger
          loop {
            token = next_token
            eliminate_pair_matches(token[1])
            logger.warn("Eliminated token: #{token.join(' ')}") if logger
            if token[1] == pairs[error_value]
              @position -= 1
              @tokens[@position] = Token.new(:S, ' ', nil) # super hack
              break
            end
          }
        end
      end

      def on_error(error_token_id, error_value, value_stack)
        if logger
          logger.error(token_to_str(error_token_id))
          logger.error("error value: #{error_value}")
        end
        eliminate_pair_matches(error_value)
      end

      def next_token
        return [false, false] if @position >= @tokens.length

        n_token = @tokens[@position]
        @position += 1
        if n_token.name == :COMMENT
          self.document_handler.comment(n_token.value)
          return next_token
        end
        n_token.to_racc_token
      end
    end
  end
