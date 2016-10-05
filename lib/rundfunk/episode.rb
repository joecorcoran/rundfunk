require 'rundfunk/wrapper'

module Rundfunk
  class Episode
    include Comparable, Wrapper

    def <=>(other)
      number <=> other.number 
    end
  end
end
