require 'rundfunk/config/validator/array_type'
require 'rundfunk/config/validator/errors'
require 'rundfunk/config/validator/type'

module Rundfunk
  class Config
    class Validator
      REGISTER = {}

      class << self
        def register(name, klass)
          REGISTER[name] = klass

          define_method(name) do |*args|
            run(name, *args)
          end

          define_method(:"#{name}_each") do |*args|
            run_each(name, *args)
          end
        end

        def [](name)
          REGISTER[name] || raise(ValidatorMissing)
        end
      end

      register :type, Type
      register :array, ArrayType

      def initialize(&block)
        @run, @run_each, @run_all = [], [], []
        instance_eval(&block) if block_given?
      end

      def run(name, *args)
        run_each(name, @_key_, *args) and return if @_key_
        @run << lookup(name).new(*args)
      end

      def run_each(name, key, *args)
        @run_each << [key, lookup(name).new(*args)]
      end

      def with(key, &block)
        @_key_ = key
        instance_eval(&block)
        @_key_ = nil
      end

      def lookup(*args)
        self.class[*args]
      end

      def call(config)
        @run.each { |v| v.call(config) }
        @run_each.each { |k, v| config.send(k).each { |x| v.call(x) } }
      rescue Error => e
        puts "Validation failed: #{e.message}" and exit
      end
    end
  end
end
