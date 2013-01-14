require 'spec_helper'

describe RequestValidator do
  let(:validator) { RequestValidator.new }

  describe '#validate' do
    before { @result = validator.validate(params) }
    subject { @result }

    context 'when valid param' do
      let(:params) { {interval: 'daily', time: '2013-01-01'} }

      it { should be_true }

      it 'should not have error message' do
        expect(validator.message).to be_nil
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
      let(:params) { {interval: 'daily'} }

      it { should be_false }
    end
  end
end
