module Danger
  # Exposes test results summary with detailed failures,
  # given a path to a JUnit report file.
  #
  # @example Ensure all the tests are executed correctly
  #
  #          junit_results.parse("/tmp/junit-report.xml")
  #          junit.report
  #
  # @see  valeriomazzeo/danger-junit_results
  # @tags junit, tests
  #
  class DangerJunitResults < Plugin

    def initialize(arg)
        super
        @skipped_count = 0
        @executed_count = 0
        @failed_count = 0
    end

    # Total number of tests skipped.
    #
    # @return   [skipped_count]
    attr_reader :skipped_count

    # Total number of tests executed.
    #
    # @return   [executed_count]
    attr_reader :executed_count

    # Total number of tests failed.
    #
    # @return   [failed_count]
    attr_reader :failed_count

    # An array of XML elements of the failed tests.
    #
    # @return   [Array<Nokogiri::Node>]
    attr_reader :failures

    # Parses tests.
    # @return   [success]
    #
    def parse(file_path)
      require 'nokogiri'

      @doc = Nokogiri::XML(File.open(file_path))

      @skipped_count = @doc.at_xpath('//testsuites/@skipped').to_s.to_i
      @executed_count = @doc.at_xpath('//testsuites/@tests').to_s.to_i - @skipped_count
      @failed_count = @doc.at_xpath('//testsuites/@failures').to_s.to_i

      @failures = @doc.xpath('//failure')

      return @failed_count <= 0
    end

    # Prints a detailed report of the tests failures.
    # @return   [success]
    #
    def report
      tests_executed_string = tests_executed == 1 ? "test" : "tests"
      tests_failed_string = tests_failed == 1 ? "failure" : "failures"

      if @failed_count > 0
        fail("Executed #{@executed_count} #{tests_executed_string}, with **#{@failed_count}** #{tests_failed_string} 🚨")
        @failures.each do |failure|
          fail("`[#{failure.content.split("/").last}] [#{failure.parent['name']}] #{failure['message']}`")
        end
      else
        message("Executed #{@executed_count} #{tests_executed_string}, with #{@failed_count} #{tests_failed_string} 🎉")
      end

      return @failed_count <= 0
    end

    def self.instance_name
      to_s.gsub("Danger", "").danger_underscore.split("/").last
    end
  end
end
