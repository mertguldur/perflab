require 'spec_helper'

describe PerfLab do
  let(:lab) do
    described_class.configure do |config|
      config.existing -> { 100.times; 100 }
      config.improved -> { 10.times; 10 }
      config.equality ->(_existing_result, _improved_result) { true }
    end
  end

  describe 'profiling' do
    let(:directory) { 'spec' }
    let(:filename) { 'perflab-profiler-test.dump' }
    let(:path) { "#{directory}/#{filename}" }

    before do
      stub_const('PerfLab::Profiler::DIRECTORY', directory)
      stub_const('PerfLab::Profiler::FILENAME', filename)
    end

    describe '.profile' do
      it 'profiles the improved lambda and creates an output file' do
        lab.profile

        expect(File.exist?(path)).to eq(true)
      end
    end

    describe '.profile_existing' do
      it 'profiles the existing lambda and creates an output file' do
        lab.profile_existing

        expect(File.exist?(path)).to eq(true)
      end
    end

    after do
      FileUtils.rm(path)
    end
  end

  describe '.bmbm' do
    it 'creates a benchmark with existing and improved lambdas' do
      results = lab.bmbm

      expect(results.size).to eq(2)
      results.each do |result|
        expect(result).to be_a(Benchmark::Tms)
      end
    end
  end

  describe '.bmbm_improved' do
    it 'creates a benchmark only with the improved lambda' do
      results = lab.bmbm_improved

      expect(results.size).to eq(1)
      expect(results.first).to be_a(Benchmark::Tms)
    end
  end

  describe '.ips' do
    it 'creates a benchmark with existing and improved lambdas' do
      result = lab.ips
      expect(result).to be_a(Benchmark::IPS::Report)
    end
  end

  describe '.ips_improved' do
    it 'creates a benchmark only with improved lambda' do
      result = lab.ips_improved
      expect(result).to be_a(Benchmark::IPS::Report)
    end
  end

  describe '.ipsa' do
    it 'creates a benchmark with existing and improved lambdas' do
      result = lab.ipsa
      expect(result).to be_a(Benchmark::IPS::Report)
    end
  end

  describe '.ipsa_improved' do
    it 'creates a benchmark only with improved lambda' do
      result = lab.ipsa_improved
      expect(result).to be_a(Benchmark::IPS::Report)
    end
  end

  describe 'equality' do
    context 'when the equality is provided' do
      it 'runs the lambda to verify correctness' do
        expect(lab).to be_correct
      end
    end

    context 'when the equality is not provided' do
      it 'compares the return values of the existing and improved lambdas to verify correctness' do
        lab = described_class.configure do |config|
          config.existing -> { 100.times; 100 }
          config.improved -> { 10.times; 10 }
        end

        expect(lab).to_not be_correct
      end
    end
  end

  describe 'performance improvement calculation' do
    context 'when improved is faster' do
      it 'prints a message saying improved is faster' do
        described_class::Util.print_performance_improvement(10, 5)
      end
    end

    context 'when improved is slower' do
      it 'prints a message saying improved is slower' do
        described_class::Util.print_performance_improvement(10, 15)
      end
    end

    context 'when there is not difference' do
      it 'prints a message saying there is no difference' do
        described_class::Util.print_performance_improvement(10, 10)
      end
    end
  end
end
