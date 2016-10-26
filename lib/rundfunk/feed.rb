require 'rundfunk/wrapper'
require 'set'

module Rundfunk
  class Feed
    include Wrapper

    def episodes
      SortedSet.new(super.map { |e| Episode.new(e) })
    end

    def rss_url
      File.join(url, 'rss.xml')
    end

    def pub_date
      episodes && episodes.to_a.last.date
    end
  end
end
