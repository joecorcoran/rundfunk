require 'fileutils'
require 'toml'
require 'rundfunk/config'
require 'rundfunk/cli/opts'

module Rundfunk
  class Cli
    class CommandNotKnown < RuntimeError; end

    def initialize(args, stdout = $stdout, stderr = $stderr)
      @args, @stdout, @stderr = args || [], stdout, stderr
    end

    def call(command)
      command ||= 'help'
      raise CommandNotKnown, command if command == 'call' || !respond_to?(command)
      public_send(command)
    end

    def help(*)
      puts "Help info here"
    end

    def sync
      opts = Opts[@args, Opt[:service, %w{-s --service}]]
      out "Syncing with options #{opts.to_h}"
    end

    def build
      opts = Opts[@args, Opt[:output, %w{-o --output}, default: 'site']]
      output_dir = File.expand_path(opts.output)
      write_file Renderer::Rss.new(feed).call, output_dir, 'rss.xml'
      write_file Renderer::Html::Index.new(feed).call, output_dir, 'index.html'
      # write episode pages to output_dir/episode_slug/index.html
    end

    private

    def config
      @config ||= begin
        opts = Opts[@args, Opt[:config, %w{-c --config}, default: 'config.toml']]
        config_path = File.expand_path(opts.config)
        raw = TOML.load_file(config_path, symbolize_keys: true)
        Config.new(validator).call(raw) if raw
      rescue SystemCallError => e
        err "Could not find config file #{config_path}"
        exit 1
      end
    end

    def feed
      @feed ||= Feed.new(config)
    end

    def out(str)
      @stdout.puts(str)
    end

    def err(str)
      @stderr.puts(str)
    end

    def write_file(contents, *path)
      file_path = File.join(*path)
      dir_path = File.dirname(file_path)
      FileUtils.mkdir_p(dir_path)
      File.open(file_path, 'w') do |file|
        out "Writing #{file_path}"
        file << contents
      end
    end

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
