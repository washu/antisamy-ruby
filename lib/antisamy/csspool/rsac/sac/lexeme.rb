module RSAC
  class Lexeme
    attr_reader :name, :pattern

    def initialize(name, pattern=nil, &block)
      raise ArgumentError, "name required" unless name

      @name = name
      patterns = []

      patterns << pattern if pattern
      yield(patterns) if block_given?

      if patterns.empty?
        raise ArgumentError, "at least one pattern required"
      end

      patterns.collect! do |spattern|
        source = spattern.source
        source = "\\A#{source}"
        Regexp.new(source, Regexp::IGNORECASE + Regexp::MULTILINE, 'n')
      end

      @pattern = Regexp.union(*patterns)
    end
  end
end
