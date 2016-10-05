require 'spec_helper'

describe Rundfunk do
  let(:config) do
    Rundfunk::Config.new.call(
      name: 'podcast',
      episodes: [
        { number: 2, title: 'two' },
        { number: 1, title: 'one' }
      ],
      keywords: ['hi', 'bye', 'hello']
    )
  end

  describe Rundfunk::Config do
    it 'creates deeply nested struct' do
      expect(config.name).to eq 'podcast'
      expect(config.episodes[0].title).to eq 'two'
    end
  end

  describe Rundfunk::Config::Validator do
    let(:type) { described_class[:type] }

    it 'calls validators' do
      validator = described_class.new do
        type :name, String
      end
      expect_any_instance_of(type).to receive(:call).with(config).once
      validator.call(config)
    end

    it 'calls validator for each key in array of structs' do
      validator = described_class.new do
        type_each :episodes, :title, String
      end
      expect_any_instance_of(type).to receive(:call).twice
      validator.call(config)
    end
  end

  describe Rundfunk::Config::Validator::Type do
    context 'type' do
      it 'does not raise when class is correct' do
        validator = described_class.new(:name, String)
        expect { validator.call(config) }.not_to raise_error
      end

      it 'raises when class is incorrect' do
        validator = described_class.new(:name, String)
        config = Rundfunk::Config.new.call(name: 1)
        expect { validator.call(config) }.to raise_error(Rundfunk::Config::Validator::InvalidType)
      end
    end

    context 'multiple types' do
      it 'does not raise when class is correct' do
        validator = described_class.new(:name, [Integer, String])
        expect { validator.call(config) }.not_to raise_error
      end

      it 'raises when class is incorrect' do
        validator = described_class.new(:name, [Integer, Hash])
        expect { validator.call(config) }.to raise_error(Rundfunk::Config::Validator::InvalidType)
      end
    end

    context 'present' do
      it 'does not raise when present is not required and key missing' do
        validator = described_class.new(:name, String, present: false)
        config = Rundfunk::Config.new.call({})
        expect { validator.call(config) }.not_to raise_error
      end

      it 'raises when present is required and key missing' do
        validator = described_class.new(:name, String)
        config = Rundfunk::Config.new.call({})
        expect { validator.call(config) }.to raise_error(Rundfunk::Config::Validator::KeyMissing)
      end
    end
  end

  describe Rundfunk::Config::Validator::ArrayType do
    it 'does not raise when class is correct' do
      validator = described_class.new(:name, String)
      config = Rundfunk::Config.new.call(name: ['hi', 'bye'])
      expect { validator.call(config) }.not_to raise_error
    end

    it 'raises when class is incorrect' do
      validator = described_class.new(:name, String)
      config = Rundfunk::Config.new.call(name: ['hi', 1])
      expect { validator.call(config) }.to raise_error(Rundfunk::Config::Validator::InvalidType)
    end
  end

  describe Rundfunk::Feed do
    let(:feed) { described_class.new(config) }

    it 'contains a sorted set of episodes' do
      expect(feed.episodes).to be_a SortedSet
      expect(feed.episodes.first.number).to eq 1
    end
  end

  describe Rundfunk::Renderer::Rss do
    let(:feed) { Rundfunk::Feed.new(config) }
    subject { described_class.new(feed) }

    it 'outputs rss'
  end
end
