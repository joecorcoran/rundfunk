module Rundfunk
  class Renderer
    def initialize(feed)
      @feed = feed
    end

    def call(render_time = Time.now)
      raise NotImplementedError
    end
  end
end
