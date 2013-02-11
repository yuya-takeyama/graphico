require 'spec_helper'

describe "Chart Model" do
  let(:chart) { Chart.new }
  it 'can be created' do
    chart.should_not be_nil
  end

  describe '#countable?' do
    let(:chart) { Chart.new(type: type) }
    subject { chart.countable? }

    context 'when type is "countable"' do
      let(:type) { 'countable' }

      it { should be_true }
    end

    context 'when type is not "countable"' do
      let(:type) { 'uncountable' }

      it { should be_false }
    end
  end

  describe '#uncountable?' do
    let(:chart) { Chart.new(type: type) }
    subject { chart.uncountable? }

    context 'when type is "uncountable"' do
      let(:type) { 'uncountable' }

      it { should be_true }
    end

    context 'when type is not "uncountable"' do
      let(:type) { 'countable' }

      it { should be_false }
    end

  end
end
