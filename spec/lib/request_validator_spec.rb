require 'spec_helper'

describe RequestValidator do
  let(:validator) { RequestValidator.new }

  describe '#validate' do
    before { @result = validator.validate(params) }
    subject { @result }

    context 'when valid params' do
      VALID_PARAMS_SET = [
        {interval: 'momentary', time: '2013'},
        {interval: 'momentary', time: '2013-01'},
        {interval: 'momentary', time: '2013-01-01'},
        {interval: 'momentary', time: '2013-01-01 00'},
        {interval: 'momentary', time: '2013-01-01 00:00'},
        {interval: 'momentary', time: '2013-01-01 00:00:00'},

        {interval: 'daily',     time: '2013-01-01'},

        {interval: 'monthly',   time: '2013-01'},
      ]

      VALID_PARAMS_SET.each do |params|
        context 'params = ' + params.inspect do
          let(:params) { params }

          it { should be_true }

          it 'should not have error message' do
            expect(validator.message).to be_nil
          end
        end
      end
    end

    context 'when invalid interval is specified' do
      let(:params) { {interval: 'foo', time: '2013-01-01'} }

      it { should be_false }

      it 'should have correct error message' do
        expect(validator.message).to eq('Invalid interval is specified')
      end
    end

    context 'when invalid time is specified' do
      INVALID_PARAMS_SET = [
        {interval: 'momentary'},
        {interval: 'momentary', time: '20131'},

        {interval: 'daily'},
        {interval: 'daily', time: '2013-01-01 00:00:00'},
        {interval: 'daily', time: '2013-01'},
        {interval: 'daily', time: '20130101'},

        {interval: 'monthly'},
        {interval: 'monthly', time: '2013-01-01 00:00:00'},
        {interval: 'monthly', time: '2013-01-01'},
        {interval: 'monthly', time: '201301'},
      ]

      INVALID_PARAMS_SET.each do |params|
        context 'params = ' + params.inspect do
          let(:params) { params }

          it { should be_false }

          it 'should have correct error message' do
            expect(validator.message).to eq("Invalid time is specified for #{params[:interval]} interval")
          end
        end
      end
    end
  end
end
