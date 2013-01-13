require 'spec_helper'

describe "DailyStat Model" do
  let(:daily_stat) { DailyStat.new }
  it 'can be created' do
    daily_stat.should_not be_nil
  end
end
