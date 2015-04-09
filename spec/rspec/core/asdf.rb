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
