require 'toml'

module Rundfunk
  class Cli
    def initialize(config_path)
      raw = TOML.load_file(File.expand_path(config_path), symbolize_keys: true)
      @config = Rundfunk::Config.new(validator).call(raw)
    end

    def validator
      Rundfunk::Config::Validator.new do
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

    def call(opts = nil)
      # dispatch renderer/writer/uploader etc.
    end
  end
end
