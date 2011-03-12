require "antisamy/csspool/rsac/sac/selectors/selector"

%w(simple child conditional descendant element sibling).each do |type|
  require "antisamy/csspool/rsac/sac/selectors/#{type}_selector"
end
