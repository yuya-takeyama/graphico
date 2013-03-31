require 'spec_helper'

describe RequestFilter do
  describe '#filter' do
    subject { RequestFilter.new.filter(params) }

    context 'when interval is "momentary" and type is not specified' do
      let(:params) { {interval: 'momentary'} }

      its(['type']) { should == 'gauge' }
    end

    context 'when interval is not "momentary"' do
      ['daily', 'monthly'].each do |interval|
        context 'type is specified' do
          context "interval is \"#{interval}\"" do
            let(:params) { {interval: interval, 'type' => 'uncountable'} }

            it 'type should not be changed' do
              should == params
            end
          end
        end

        context 'type is not specified' do
          context "interval is \"#{interval}\"" do
            let(:params) { {interval: interval} }

            its(['type']) { should == 'countable' }
          end
        end
      end
    end
  end
end
