require 'active_support/all'
require 'benchmark'
require 'benchmark/ipsa'
require 'stackprof'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup
loader.eager_load

module PerfLab
  module_function

  def configure
    config = Config.new
    yield config
    Operator.new(config.lambdas)
  end
end
