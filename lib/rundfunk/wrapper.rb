module Rundfunk
  module Wrapper
    def initialize(config)
      @config = config
    end

    def method_missing(*args)
      @config.send(*args)
    end
  end
end
