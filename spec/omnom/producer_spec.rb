RSpec.describe Omnom::Producer do
  let(:adapter) { Support::TestAdapter.new(1..5) }
  let(:buffer_size) { 2 }
  let(:poll_interval_ms) { 20 }

  let :config do
    Omnom::Config.new(
      adapter: adapter,
      buffer_size: buffer_size,
      poll_interval_ms: poll_interval_ms
    )
  end

  subject { described_class.new(config) }

  describe "#pop" do
    it "keeps filling the buffer (if not terminating)" do
      expect(subject.pop.message).to eq 1
      expect(subject.pop.message).to eq 2
      expect(subject.pop.message).to eq 3
      expect(subject.pop.message).to eq 4
      expect(subject.pop.message).to eq 5
    end

    it "if stopped doesn't fill the buffer" do
      expect(subject.pop.message).to eq 1

      # give the producer some time to fill the buffer
      sleep(0.04)

      subject.stop

      expect(subject.pop.message).to eq 2
      expect(subject.pop.message).to eq 3
      expect(subject.pop).to eq nil
      expect(subject.pop).to eq nil
      expect(subject.pop).to eq nil
    end
  end
end
