require 'spec_helper'

describe "Graph Model" do
  let(:graph) { Graph.new }
  it 'can be created' do
    graph.should_not be_nil
  end
end
