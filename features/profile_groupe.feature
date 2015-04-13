Feature: Profile group example

  Scenario: Slowest before hook should be show
    Given a file named "spec/spec_helper.rb" with:
      """ruby
      RSpec.configure { |c| c.profile_examples = 1 }
      """
    And a file named "spec/example_spec.rb" with:
      """ruby
      require "spec_helper"

      RSpec.describe "slow example" do
        it "slow example" do
          sleep 0.2
          expect(10).to eq(10)
        end
      end
      RSpec.describe "slow before context hook" do
        before(:context) do
          sleep 0.3
        end
        it "example" do
          expect(10).to eq(10)
        end
      end

      """
    When I run `rspec spec`
    Then the output should contain "slow before context hook"
