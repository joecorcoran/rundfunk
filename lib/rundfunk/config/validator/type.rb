require 'rundfunk/config/validator/errors'
require 'rundfunk/config/validator/lookup'
require 'rundfunk/config/validator/present'

module Rundfunk
  class Config
    class Validator
      class Type
        include Lookup, Present

        def initialize(key, type, **options)
          @key, @type, @options = key, type, options
        end

        def valid?(subject)
          Array(@type).any? { |t| t === subject }
        end

        def error(subject)
          raise InvalidType.new(@key, @type, subject.class)
        end

        def call(config)
          subject = lookup(@key, config)
          enforce_present? ? enforce_present!(subject) : return
          error(subject) unless valid?(subject)
        end
      end
    end
  end
end
