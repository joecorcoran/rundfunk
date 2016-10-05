require 'rundfunk/config/validator'

require 'toml'
require 'ostruct'

module Rundfunk
  class Config
    def self.load(path)
      new.call()
    end

    def initialize(validator = Validator.new)
      @validator = validator
    end

    def call(hash)
      normalize(hash).tap { |c| @validator.call(c) }
    end

    private

    def normalize(subject)
      case subject
      when Hash then normalize_hash(subject)
      when Array then normalize_array(subject)
      else subject
      end
    end

    def normalize_hash(subject)
      OpenStruct.new.tap do |o|
        subject.each do |k, v|
          o[k] = normalize(v)
          o.send(:new_ostruct_member, k)
        end
      end
    end

    def normalize_array(subject)
      subject.map { |x| normalize(x) }
    end
  end
end
