module PerfLab
  class Util
    class << self
      def print_performance_improvement(existing_result, improved_result)
        percentage = ((improved_result.to_f - existing_result.to_f) / existing_result.to_f) * 100

        if percentage < 0
          puts "Improved is #{percentage.abs.round(2)}% faster"
        elsif percentage > 0
          puts "Improved is #{percentage.abs.round(2)}% slower"
        else
          puts 'No difference in speed'
        end
      end
    end
  end
end
