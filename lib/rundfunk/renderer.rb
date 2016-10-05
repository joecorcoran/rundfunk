module Rundfunk
  class Renderer
    def initialize(feed)
      @feed = feed
    end

    def call
      raise NotImplementedError
    end
  end
end
