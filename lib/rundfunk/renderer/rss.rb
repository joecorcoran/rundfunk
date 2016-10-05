require 'oga'

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

    def items
      @items ||= @feed.episodes.map do |episode|
        element('item') do |item|
          item.children << element('title') { |e| e.inner_text = episode.title }
        end
      end
    end

    def element(name, **args, &block)
      Oga::XML::Element.new(**args.merge(name: name)).tap do |e|
        block.call(e) if block_given?
      end
    end

    def call
      doc.tap do |d|
        channel.children.concat(items)
        root.children << channel
        d.children << root
      end.to_xml
    end
  end
end
