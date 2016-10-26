require 'rundfunk/wrapper'

module Rundfunk
  class Episode
    include Comparable, Wrapper

    def <=>(other)
      date <=> other.date
    end
  end
end
