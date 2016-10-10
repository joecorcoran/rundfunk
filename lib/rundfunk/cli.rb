require 'toml'
require 'rundfunk/config'
require 'rundfunk/cli/opts'

module Rundfunk
  class Cli
    class CommandNotKnown < RuntimeError; end

    def initialize(config_path)
      raw = TOML.load_file(File.expand_path(config_path), symbolize_keys: true)
      @config = Config.new(validator).call(raw)
    end

    def call(command = 'help', args = [])
      raise CommandNotKnown, command if command == 'call' || !respond_to?(command)
      public_send(command, args)
    end

    def help(*)
      puts "Help info here"
    end

    def sync(args)
      parser = Opts.new(
        Opt.new(:number, ['-n', '--number'], default: 0) { |n| n.to_i },
        Opt.new(:service, ['-s', '--service'])
      )
      puts "Syncing with options #{parser.call(args).to_h}"
    end

    def build(args)
      parser = Opts.new(
        Opt.new(:output, ['-o', '--output'], default: 'all')
      )
      puts "Building with options #{parser.call(args).to_h}"
    end

    private

    def validator
      Config::Validator.new do
        type :title, String
        type :url, String
        type :copyright, String
        type :summary, String
        type :image, String
        array :keywords, String
        array :categories, String
        type :explicit, [TrueClass, FalseClass]
        type :description, String
        type :subtitle, String
        type [:owner, :name], String
        type [:owner, :email], String

        with :episodes do
          type :number, Integer
          type :title, String
          type :subtitle, String
          type :date, Time
          type :slug, String
          type :image, String
          type :description, String
          type :file, String
          type :duration, String
          type :explicit, [TrueClass, FalseClass]
          array :keywords, String
        end
      end
    end
  end
end
