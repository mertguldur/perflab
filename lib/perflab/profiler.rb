module PerfLab
  class Profiler
    DIRECTORY = 'tmp/perflab'.freeze
    FILENAME = 'profiler.dump'.freeze

    class << self
      def profile(lambda)
        FileUtils.mkdir_p(DIRECTORY)
        path = "#{DIRECTORY}/#{FILENAME}"

        StackProf.run(mode: :wall, out: path, raw: true) { lambda.call }
      end
    end
  end
end
