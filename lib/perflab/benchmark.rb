module PerfLab
  class Benchmark
    EXISTING = 'existing'.freeze
    IMPROVED = 'improved'.freeze

    class << self
      def bmbm(improved, existing = nil)
        results = ::Benchmark.bmbm do |x|
          x.report(EXISTING) { existing.call } if existing.present?
          x.report(IMPROVED) { improved.call }
        end

        return results unless existing.present?

        print_bmbm_improvement(results)
        results
      end

      def ips(improved, existing = nil)
        ::Benchmark.ips do |x|
          x.config(warmup: 1, time: 1)

          x.report(EXISTING) { existing.call } if existing.present?
          x.report(IMPROVED) { improved.call }

          x.compare!
        end
      end

      def ipsa(improved, existing = nil)
        ::Benchmark.ipsa do |x|
          x.config(warmup: 1, time: 1)

          x.report(EXISTING) { existing.call } if existing.present?
          x.report(IMPROVED) { improved.call }

          x.compare!
        end
      end

      private

      def print_bmbm_improvement(results)
        existing_wall_time = results.find { |result| result.label == EXISTING }.real
        improved_wall_time = results.find { |result| result.label == IMPROVED }.real

        Util.print_performance_improvement(existing_wall_time, improved_wall_time)
      end
    end
  end
end
