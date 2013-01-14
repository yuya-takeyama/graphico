require 'spec_helper'

describe "Chart Model" do
  let(:chart) { Chart.new }
  it 'can be created' do
    chart.should_not be_nil
  end
end
