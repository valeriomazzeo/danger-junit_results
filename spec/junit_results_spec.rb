require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerJunitResults do
    it 'should be a plugin' do
      expect(Danger::DangerJunitResults.new(nil)).to be_a Danger::Plugin
    end

    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @junit_results = @dangerfile.junit_results
      end

      describe 'without failures' do

        before do
          @junit_results.parse("./spec/fixtures/junit-report.xml")
        end

        it "has to parse tests" do

          expect(@junit_results.total_count).to eq(5)
          expect(@junit_results.skipped_count).to eq(3)
          expect(@junit_results.executed_count).to eq(2)
          expect(@junit_results.failed_count).to eq(0)
          expect(@junit_results.failures).to be_empty
          expect(@dangerfile.status_report[:messages]).to be_empty
          expect(@dangerfile.status_report[:warnings]).to be_empty
          expect(@dangerfile.status_report[:errors]).to be_empty
          expect(@dangerfile.status_report[:markdowns]).to be_empty
        end

        it "has to report successfully" do
          expect(@junit_results.report).to be true
          expect(@dangerfile.status_report[:messages].first).to eq("Executed 2(5) tests, with 0 failures 🎉")
          expect(@dangerfile.status_report[:warnings]).to be_empty
          expect(@dangerfile.status_report[:errors]).to be_empty
          expect(@dangerfile.status_report[:markdowns]).to be_empty
        end

      end

      describe 'with failures' do

        before do
          @junit_results.parse("./spec/fixtures/junit-report-failures.xml")
        end

        it "has to parse tests" do

          expect(@junit_results.total_count).to eq(5)
          expect(@junit_results.skipped_count).to eq(3)
          expect(@junit_results.executed_count).to eq(2)
          expect(@junit_results.failed_count).to eq(1)
          expect(@junit_results.failures).not_to be_empty
          expect(@dangerfile.status_report[:messages]).to be_empty
          expect(@dangerfile.status_report[:warnings]).to be_empty
          expect(@dangerfile.status_report[:errors]).to be_empty
          expect(@dangerfile.status_report[:markdowns]).to be_empty
        end

        it "has to report successfully" do
          expect(@junit_results.report).to be false
          expect(@junit_results.failures).not_to be_empty
          expect(@junit_results.failures.first.class).to eq(Nokogiri::XML::Element)
          expect(@dangerfile.status_report[:messages]).to be_empty
          expect(@dangerfile.status_report[:warnings]).to be_empty
          expect(@dangerfile.status_report[:errors].first).to eq("Executed 2(5) tests, with **1** failure 🚨")
          expect(@dangerfile.status_report[:errors][1]).to eq("`[Assertion failed] [should default path to an empty string] test failure`")
          expect(@dangerfile.status_report[:markdowns]).to be_empty
        end

      end

    end
  end
end
