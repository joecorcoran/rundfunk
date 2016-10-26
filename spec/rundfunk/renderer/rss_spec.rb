require 'spec_helper'

describe Rundfunk::Renderer::Rss do
  let(:config) { load_config }
  let(:feed) { Rundfunk::Feed.new(config) }

  subject { described_class.new(feed).call(Time.new(1979, 5, 29, 0, 0, 0, 0)) }

  def node_at(xpath)
    Oga.parse_xml(subject).at_xpath(xpath)
  end

  def value_at(xpath)
    node_at(xpath).value
  end

  def text_at(xpath)
    node_at(xpath).text
  end

  def be_url
    match(%r{^https?://.+$})
  end

  describe 'root' do
    example { expect(value_at('rss/@version')).to eq '2.0' }
    example { expect(value_at('rss/@xmlns:atom')).to be_url }
    example { expect(value_at('rss/@xmlns:cc')).to be_url }
    example { expect(value_at('rss/@xmlns:itunes')).to be_url }
    example { expect(value_at('rss/@xmlns:media')).to be_url }
    example { expect(value_at('rss/@xmlns:rdf')).to be_url }
  end

  describe 'metadata' do
    example { expect(text_at('rss/channel/title')).to eq 'Podcast Site' }
    example { expect(text_at('rss/channel/pubDate')).to eq 'Mon, 28 May 1979 00:32:00 -0700' }
    example { expect(text_at('rss/channel/lastBuildDate')).to eq 'Tue, 29 May 1979 00:00:00 +0000' }
    example { expect(text_at('rss/channel/generator')).to eq "Rundfunk #{Rundfunk::VERSION}" }
    example { expect(text_at('rss/channel/link')).to eq 'https://podcast.site' }
    example { expect(text_at('rss/channel/language')).to eq 'en' }
    example { expect(text_at('rss/channel/copyright')).to eq '2016 Podcast owner' }
    example { expect(text_at('rss/channel/docs')).to eq 'https://podcast.site' }
    example { expect(text_at('rss/channel/description')).to eq 'Description of podcast' }
    example { expect(value_at('rss/channel/atom:link/@href')).to eq 'https://podcast.site/rss.xml' }
  end

  describe 'itunes metadata' do
  end

  describe 'items' do
  end
end
