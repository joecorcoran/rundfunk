require 'oga'
require 'time'

module Rundfunk
  class Renderer::Rss < Renderer
    def decl
      @decl ||= Oga::XML::XmlDeclaration.new(version: '1.0', encoding: 'UTF-8')
    end

    def doc
      @doc ||= Oga::XML::Document.new(xml_declaration: decl)
    end

    def root
      @root ||= element('rss') do |e|
        e['version'] = '2.0'
        e['xmlns:atom'] = 'http://www.w3.org/2005/Atom'
        e['xmlns:cc'] = 'http://web.resource.org/cc/'
        e['xmlns:itunes'] = 'http://www.itunes.com/dtds/podcast-1.0.dtd'
        e['xmlns:media'] = 'http://search.yahoo.com/mrss/'
        e['xmlns:rdf'] = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'
      end
    end

    def channel
      @channel ||= element('channel')
    end

    def metadata(render_time)
      @metadata ||= [
        element('title') { |e| e.inner_text = @feed.title },
        element('pubDate') { |e| e.inner_text = @feed.pub_date.rfc822 },
        element('lastBuildDate') { |e| e.inner_text = render_time.rfc822 },
        element('generator') { |e| e.inner_text = "Rundfunk #{VERSION}" },
        element('link') { |e| e.inner_text = @feed.url },
        element('language') { |e| e.inner_text = @feed.language },
        element('copyright') { |e| e.children << cdata(@feed.copyright) },
        element('docs') { |e| e.inner_text = @feed.url },
        element('description') { |e| e.children << cdata(@feed.description) },
        element('atom:link', href: @feed.rss_url, rel: 'self', type: 'application/rss+xml')
      ]
    end

    def items
      @items ||= @feed.episodes.map do |episode|
        element('item') do |item|
          item.children << element('title') { |e| e.inner_text = episode.title }
        end
      end
    end

    def call(render_time = Time.now)
      doc.tap do |d|
        channel.children.concat(metadata(render_time))
        channel.children.concat(items)
        root.children << channel
        d.children << root
      end.to_xml
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

    def cdata(text = '')
      Oga::XML::Cdata.new(text: text)
    end
  end
end
