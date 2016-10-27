module Rundfunk
  class Config
    class Validator
      module Present
        def enforce_present?
          @options.fetch(:present, true)
        end

        def enforce_present!(subject)
          raise(KeyMissing, @key) unless subject
        end
      end
    end
  end
end
