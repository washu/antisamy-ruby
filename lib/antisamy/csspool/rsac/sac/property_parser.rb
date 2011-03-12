require "antisamy/csspool/rsac/sac/generated_property_parser"

module RSAC
  class PropertyParser < RSAC::GeneratedPropertyParser
    def initialize
      @tokens = []
      @token_table = Racc_arg[10]
    end

    def parse_tokens(tokens)
      negate = false # Nasty hack for unary minus
      @tokens = tokens.find_all { |x| x.name != :S }.map { |token|
        tok = if @token_table.has_key?(token.value)
        [token.value, token.value]
      else
        if token.name == :delim && !@token_table.has_key?(token.value)
          negate = true if token.value == '-'
          nil
        else
          token.to_racc_token
        end
      end

      if negate && tok
        tok[1] = "-#{tok[1]}"
        negate = false
      end
      tok
    }.compact

    begin
      return do_parse
    rescue ParseError => e
      return nil
    end
  end

  private
  def next_token
    return [false, false] if @tokens.empty?
    @tokens.shift
  end
end
end
