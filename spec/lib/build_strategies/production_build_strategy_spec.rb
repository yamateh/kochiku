require "spec_helper"
# Including the production strategy is potentially dangerous but we stub out command execution.
require "#{Rails.root}/lib/build_strategies/production_build_strategy.rb"

describe BuildStrategy do
  let(:project) { FactoryGirl.create(:big_rails_project) }
  let(:build) { FactoryGirl.create(:build, :project => project, :queue => "developer") }

  before(:each) do
    CommandStubber.new # ensure Open3 is stubbed

    Rails.application.config.action_mailer.delivery_method.should == :test
  end

  describe "#merge_ref" do
    context "when auto_merge is enabled" do
      it "should merge to master" do
        merger = GitAutomerge.new
        GitAutomerge.should_receive(:new).and_return(merger)
        merger.should_receive(:automerge)

        BuildStrategy.merge_ref(build).should_not be_nil
      end
    end
  end
end