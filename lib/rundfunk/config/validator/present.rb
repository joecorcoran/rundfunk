module Rundfunk
  class Config
    class Validator
      module Present
        def enforce_present?
          @options.fetch(:present, true)
        end

        def enforce_present!(subject)
          raise KeyMissing unless subject
        end
      end
    end
  end
end
