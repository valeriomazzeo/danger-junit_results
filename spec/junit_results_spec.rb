require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerXcodebuild do
    it 'should be a plugin' do
      expect(Danger::DangerXcodebuild.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @junit_results = @dangerfile.junit_results
      end

      describe 'without failures' do

        it "has to parse failed tests" do
          @junit_results.parse("fixtures/junit-report.xml")
          expect(@junit_results.skipped_count).to eq(1)
          expect(@junit_results.executed_count).to eq(2)
          expect(@junit_results.failed_count).to eq(0)
          expect(@junit_results.failures).to be_nil
          expect(@dangerfile.status_report[:messages]).to be_empty
          expect(@dangerfile.status_report[:warnings]).to be_empty
          expect(@dangerfile.status_report[:errors]).to be_empty
          expect(@dangerfile.status_report[:markdowns]).to be_empty
        end

      end

    end
  end
end
