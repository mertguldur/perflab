# PerfLab

[![CircleCI](https://circleci.com/gh/mertguldur/perflab.svg?style=svg)](https://circleci.com/gh/mertguldur/perflab)

## Introduction

PerfLab is a unified interface for [stackprof](https://github.com/tmm1/stackprof), [benchmark](https://ruby-doc.org/stdlib-2.6.3/libdoc/benchmark/rdoc/Benchmark.html), [benchmark-ips](https://github.com/evanphx/benchmark-ips/) and [benchmark-ipsa](https://github.com/jondot/benchmark-ipsa) libraries. It allows performance testers to define code snippets they want to improve and benchmark against only once. It is designed to streamline the Profile -> Benchmark -> Iterate process. 

## Setup

Install [graphviz](https://www.graphviz.org/) to create dot graphs from profiler output files.

In your Gemfile:

```ruby
gem 'perflab'
```

Specify the code snippet you already have and the one you want to improve.

```ruby
lab = PerfLab.configure do |config|
  config.existing -> { MyService.slow_code }
  config.improved -> { MyService.fast_code }
end
```

## Profiling

PerfLab uses `stackprof` to profile the given improved code snippet.

```ruby
lab.profile # profiles the 'improved' snippet and writes to tmp/perflab/profiler.dump

lab.profile_existing # same as .profile except that it profiles the 'existing' snippet
```

It is recommended to convert the dump file to a dot graph to easily interpret the report.

Bash example:

```bash
function prof {
  stackprof tmp/perflab/profiler.dump --graphviz > tmp/perflab/profiler.dot
  dot -Tpng tmp/perflab/profiler.dot > tmp/perflab/profiler.png
  open -a 'Google Chrome' tmp/perflab/profiler.png
}
```

For other ways of examining the profiler report please refer to [stackprof](https://github.com/tmm1/stackprof).

## Benchmarking

PerfLab provides wrappers for [Benchmark.bmbm](https://ruby-doc.org/stdlib-2.6.3/libdoc/benchmark/rdoc/Benchmark.html#method-c-bmbm), [Benchmark.ips](https://github.com/evanphx/benchmark-ips/) and [Benchmark.ipsa](https://github.com/jondot/benchmark-ipsa) methods.

```ruby
lab.bmbm # calls Benchmark.bmbm with both
lab.bmbm_improved # calls Benchmark.bmbm with only improved

lab.ips # calls Benchmark.ips with both
lab.ips_improved # calls Benchmark.ips with only improved

lab.ipsa # calls Benchmark.ipsa with both
lab.ipsa_improved # calls Benchmark.ipsa with only improved
```

It sets up `ips` and `ipsa` with one rehearsal round and favors `bmbm` over `bm` to minimize memory allocation and GC side effects.

## Verifying correctness

PerfLab has a `correct?` method to verify that the `improved` snippet behaves exactly like `existing`.

```ruby
lab.correct?
=> # true or false
```

By default it compares the return values of the snippets but one can pass in an `equality` lambda for additional checks.

```ruby
lab = PerfLab.configure do |config|
  config.existing -> { MyService.slow_code }
  config.improved -> { MyService.fast_code }
  config.equality ->(existing_result, improved_result) {
    existing_result == improved_result && MyModel.count == 500
  } # optional
end
```

## Thanks

This was written on [tastyworks'](https://tastyworks.com/) time.
