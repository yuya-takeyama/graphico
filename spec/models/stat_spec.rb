require 'spec_helper'

describe "Stat Model" do
  let(:stat) { Stat.new }
  it 'can be created' do
    stat.should_not be_nil
  end
end
