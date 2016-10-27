require 'oga'
require 'time'

module Rundfunk
  class Renderer
    def initialize(feed)
      @feed = feed
    end

    def call(render_time = Time.now)
      raise NotImplementedError
    end

    private

    def element(name, **attrs, &block)
      Oga::XML::Element.new(name: name).tap do |e|
        attrs.each do |k, v|
          e[k] = v
        end
        block.call(e) if block_given?
      end
    end
  end
end
