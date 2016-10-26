require 'spec_helper'

RSpec.describe Rundfunk::Feed do
  let(:config) { load_config }
  let(:feed) { described_class.new(config) }

  it 'contains a sorted set of episodes' do
    expect(feed.episodes).to be_a SortedSet
    expect(feed.episodes.first.title).to eq 'Episode 1'
  end
end
