module Rundfunk
  class Renderer::Html < Renderer
    require 'rundfunk/renderer/html/index'
    require 'rundfunk/renderer/html/episode'

    def call(render_time = Time.now)
      # render index and episode pages
      # Renderer::Html::Index
      # Renderer::Html::Episode
    end
  end
end
