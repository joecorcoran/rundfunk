$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rundfunk'
require 'toml'

def load_config
  Rundfunk::Config.new.call(TOML.load_file(File.expand_path('../fixtures/example.toml', __FILE__)))
end
