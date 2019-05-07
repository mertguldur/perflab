module PerfLab
  class Operator
    def initialize(existing:, improved:, equality:)
      @existing = existing
      @improved = improved
      @equality = equality
    end

    def profile
      puts 'Rehearsal...'
      @improved.call

      puts 'Profiling...'
      Profiler.profile(@improved)
    end

    def profile_existing
      puts 'Rehearsal...'
      @existing.call

      puts 'Profiling...'
      Profiler.profile(@existing)
    end

    def bmbm
      Benchmark.bmbm(@improved, @existing)
    end

    def bmbm_improved
      Benchmark.bmbm(@improved)
    end

    def ips
      Benchmark.ips(@improved, @existing)
    end

    def ips_improved
      Benchmark.ipsa(@improved)
    end

    def ipsa
      Benchmark.ipsa(@improved, @existing)
    end

    def ipsa_improved
      Benchmark.ipsa(@improved)
    end

    def correct?
      if @equality.present?
        result = @equality.call(@existing.call, @improved.call)
        raise ArgumentError, 'Equality must return a boolean' unless [TrueClass, FalseClass].include?(result.class)

        result
      else
        @existing.call == @improved.call
      end
    end
  end
end
