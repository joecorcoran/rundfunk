module Rundfunk
  class Config
    class Validator
      class Error < StandardError; end

      class InvalidType < Error
        def initialize(key, should, is)
          @key, @should, @is = key, should, is
        end

        def message
          "#{@key.inspect} must be #{@should} but is #{@is}"
        end
      end

      class KeyMissing < Error; end
      class ValidatorMissing < Error; end
    end
  end
end
