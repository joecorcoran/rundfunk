require 'rundfunk/config/validator/type'

module Rundfunk
  class Config
    class Validator
      class ArrayType < Type
        def valid?(subject)
          (Array === subject) && subject.all? { |x| Array(@type).any? { |t| t === x } }
        end
      end
    end
  end
end
