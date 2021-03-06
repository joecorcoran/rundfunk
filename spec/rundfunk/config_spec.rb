require 'spec_helper'

RSpec.describe Rundfunk::Config do
  let(:config) { load_config }

  it 'creates deeply nested struct' do
    expect(config.title).to eq 'Podcast Site'
    expect(config.episodes[0].title).to eq 'Episode 1'
  end

  describe Rundfunk::Config::Validator do
    let(:type) { described_class[:type] }

    it 'calls validators' do
      validator = described_class.new do
        type :title, String
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
        validator = described_class.new(:title, String)
        expect { validator.call(config) }.not_to raise_error
      end

      it 'raises when class is incorrect' do
        validator = described_class.new(:title, String)
        config = Rundfunk::Config.new.call(title: 1)
        expect { validator.call(config) }.to raise_error(Rundfunk::Config::Validator::InvalidType)
      end
    end

    context 'multiple types' do
      it 'does not raise when class is correct' do
        validator = described_class.new(:title, [Integer, String])
        expect { validator.call(config) }.not_to raise_error
      end

      it 'raises when class is incorrect' do
        validator = described_class.new(:title, [Integer, Hash])
        expect { validator.call(config) }.to raise_error(Rundfunk::Config::Validator::InvalidType)
      end
    end

    context 'present' do
      it 'does not raise when present is not required and key missing' do
        validator = described_class.new(:title, String, present: false)
        config = Rundfunk::Config.new.call({})
        expect { validator.call(config) }.not_to raise_error
      end

      it 'raises when present is required and key missing' do
        validator = described_class.new(:title, String)
        config = Rundfunk::Config.new.call({})
        expect { validator.call(config) }.to raise_error(Rundfunk::Config::Validator::KeyMissing)
      end
    end
  end

  describe Rundfunk::Config::Validator::ArrayType do
    it 'does not raise when class is correct' do
      validator = described_class.new(:title, String)
      config = Rundfunk::Config.new.call(title: ['hi', 'bye'])
      expect { validator.call(config) }.not_to raise_error
    end

    it 'raises when class is incorrect' do
      validator = described_class.new(:title, String)
      config = Rundfunk::Config.new.call(title: ['hi', 1])
      expect { validator.call(config) }.to raise_error(Rundfunk::Config::Validator::InvalidType)
    end
  end
end
