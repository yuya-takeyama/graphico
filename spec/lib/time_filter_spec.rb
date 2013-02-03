require 'spec_helper'

describe TimeFilter do
  let(:filter) { TimeFilter.new }

  describe '#convert' do
    before { @result = filter.convert(interval, time) }
    subject { @result }

    context 'when daily' do
      let(:interval) { 'daily' }

      context 'time is 2013-01-01' do
        let(:time) { '2013-01-01' }

        it { should == '2013-01-01' }
      end
    end

    context 'when monthly' do
      let(:interval) { 'monthly' }

      context 'time is 2013-01' do
        let(:time) { '2013-01' }

        it { should == '2013-01-01' }
      end
    end
  end
end
