require 'spec_helper'

describe RequestFilter do
  describe '#filter' do
    let(:filtered_params) { RequestFilter.new.filter(params) }

    describe "params['type']" do
      subject { filtered_params['type'] }

      context 'when interval is "momentary" and type is not specified' do
        let(:params) { {interval: 'momentary'} }

        it { should == 'gauge' }
      end

      context 'when interval is not "momentary"' do
        ['daily', 'monthly'].each do |interval|
          context 'type is specified' do
            context "interval is \"#{interval}\"" do
              let(:params) { {interval: interval, 'type' => 'uncountable'} }

              it 'type should not be changed' do
                should == 'uncountable'
              end
            end
          end

          context 'type is not specified' do
            context "interval is \"#{interval}\"" do
              let(:params) { {interval: interval} }

              it { should == 'countable' }
            end
          end
        end
      end
    end

    describe "params['default_interval']" do
      subject { filtered_params['default_interval'] }

      context 'type is gauge' do
        [
          {time: '2013-01-01', expected: 'daily'},
          {time: '2013-01', expected: 'monthly'},
        ].each do |input|
          context "time = #{input[:time]}" do
            let(:params) { {'type' => 'gauge', time: input[:time]} }

            it { should == input[:expected] }
          end
        end
      end

      context 'type is not gauge' do
        ['countable', 'uncountable'].each do |type|
          context "type is #{type}" do
            let(:params) { {'type' => type, interval: 'daily'} }

            it 'should be specified interval' do
              should == 'daily'
            end
          end
        end
      end
    end
  end
end
