module Rundfunk
  class Renderer::Html
    module Template
      def doctype
        Oga::XML::Doctype.new(name: 'html')
      end

      def doc
        Oga::XML::Document.new(doctype: doctype)
      end

      def head
        element('head')
      end

      def body
        element('body')
      end

      def html
        element('html') do |html|
          html.children << head
          html.children << body
        end
      end

      def call(render_time = Time.now)
        doc.tap do |d|
          d.children << html
        end.to_xml
      end
    end
  end
end
