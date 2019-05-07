module PerfLab
  class Config
    def existing(existing)
      @existing = existing
    end

    def improved(improved)
      @improved = improved
    end

    def equality(equality)
      @equality = equality
    end

    def lambdas
      {
        existing: @existing,
        improved: @improved,
        equality: @equality
      }
    end
  end
end
