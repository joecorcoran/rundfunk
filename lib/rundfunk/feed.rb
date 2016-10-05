require 'rundfunk/wrapper'
require 'set'

module Rundfunk
  class Feed
    include Wrapper

    def episodes
      SortedSet.new(super.map { |e| Episode.new(e) })
    end
  end
end
