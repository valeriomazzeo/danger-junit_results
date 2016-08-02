# danger-junit_results

Exposes test results summary with detailed failures, given a path to a JUnit report file.

## Installation

    $ gem install danger-junit_results

## Usage

    junit_results.parse("/tmp/junit-report.xml")
    junit_results.parse

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
