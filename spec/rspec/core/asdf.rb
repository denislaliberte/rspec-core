
module RSpec
  module Core
    RSpec.describe "asdf" do
      before(:context) do
        sleep 1
      end
      it "asdf" do
        expect(true).to eq(true)
      end
    end
    RSpec.describe "asdf1" do
      it "asdf" do
        expect(1).to eq(1)
      end
    end
    RSpec.describe "asdf2" do
      it "asdf" do
        expect(2).to eq(2)
      end
    end
    RSpec.describe "asdf3" do
      it "asdf" do
        expect(3).to eq(3)
      end
    end
  end
end
