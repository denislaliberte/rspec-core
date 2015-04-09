#todo move to example test spec
slow_before_context = RSpec.describe "slow before context" do
  before(:context) do
    sleep 1
  end
  it "qwer" do
    expect(10).to eq(10)
  end
end

RSpec.describe "record example group execution" do
  slow_before_context.run
  it { expect( slow_before_context.parent_groups.last.before_run_time ).to be > 1 }
  #it { expect( slow_before_context.before_run_time ).to be > 1 }
end
