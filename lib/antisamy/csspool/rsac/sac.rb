require "antisamy/csspool/rsac/sac/conditions"
require "antisamy/csspool/rsac/sac/selectors"
require "antisamy/csspool/rsac/sac/parser"
require "antisamy/csspool/rsac/stylesheet"

module RSAC
  class << self
    def parse(text)
      parser = CSS::SAC::Parser.new
      parser.parse(text)
      parser
    end
  end
end
