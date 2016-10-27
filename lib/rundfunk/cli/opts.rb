require 'ostruct'

module Rundfunk
  class Cli
    class OptMissing < RuntimeError
      def message
        "Option #{super} not found"
      end
    end

    class Opts
      include Enumerable

      def self.[](argv, *opts)
        parser = new(*opts)
        parser.call(argv)
      end

      def initialize(*opts)
        @opts = opts
      end

      def each(&block)
        @opts.each(&block)
      end

      def call(argv)
        OpenStruct.new.tap do |struct|
          args = normalize(argv.dup)

          while pair = args.shift(2) do
            key, value = pair
            break unless value && key.start_with?('-')
            each { |opt| opt.apply_value!(struct, key, value) }
          end

          each { |opt| opt.apply_default!(struct, key) }
        end
      rescue OptMissing => e
        puts e.message
        exit
      end

      private

      def normalize(args)
        args.flat_map do |arg, idx|
          key, value = arg.split('=')
          value ? [key, value] : arg 
        end
      end
    end

    class Opt
      def self.[](*args, **kwargs, &coerce)
        new(*args, **kwargs, &coerce)
      end

      def initialize(name, formats, default: nil, &coerce)
        @name, @formats, @default, @coerce = name, formats, default, coerce
      end

      def match?(format)
        @formats.include?(format)
      end

      def apply_value!(struct, key, value)
        return if struct.respond_to?(@name)
        struct.send(:"#{@name}=", coerce(value)) if match?(key)
      end

      def apply_default!(struct, key)
        return if struct.respond_to?(@name)
        raise OptMissing, self unless @default
        struct.send(:"#{@name}=", coerce(@default))
      end

      def coerce(value)
        @coerce ? @coerce.call(value) : value
      end

      def to_s
        "#{@name} (#{@formats.join(', ')})"
      end
    end
  end
end
