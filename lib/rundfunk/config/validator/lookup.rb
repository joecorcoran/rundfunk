module Rundfunk
  class Config
    class Validator
      module Lookup
        def lookup(key, config)
          Array(key).reduce(config) do |result, k|
            result && result.send(k)
          end
        end
      end
    end
  end
end
