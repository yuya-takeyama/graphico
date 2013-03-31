require 'spec_helper'

describe 'MorrisChart' do
  context 'when countable' do
    context 'when monthly interval' do
      before do
        @chart = Chart.new(
          name: 'example_chart',
          type: 'countable',
          default_interval: 'daily',
        )
        @stats = [
          Stat.new(time: DateTime.new(2013, 1, 1), count: 1000),
          Stat.new(time: DateTime.new(2013, 1, 2), count: 1200),
          Stat.new(time: DateTime.new(2013, 2, 1), count: 1500),
        ]
        @interval = 'monthly'
      end

      subject do
        MorrisChart.new(
          chart: @chart,
          stats: @stats,
          interval: @interval,
        ).to_hash
      end

      it 'should be correct hash' do
        should eq({
          element: 'chart',
          data: [
            {time: '2013-01', c: 2200},
            {time: '2013-02', c: 1500},
          ],
          xkey: 'time',
          ykeys: ['c'],
          labels: ['example_chart'],
          xLabels: 'month',
        })
      end
    end
  end

  context 'when uncountable' do
    context 'when daily interval' do
      before do
        @chart = Chart.new(name: 'example_chart', type: 'uncountable')
        @stats = [
          Stat.new(time: DateTime.new(2013, 1, 1), count: 1000),
          Stat.new(time: DateTime.new(2013, 1, 2), count: 1200),
          Stat.new(time: DateTime.new(2013, 1, 3), count: 1500),
        ]
        @interval = 'daily'
      end

      subject do
        MorrisChart.new(
          chart: @chart,
          stats: @stats,
          interval: @interval,
        ).to_hash
      end

      it 'should be correct hash' do
        should eq({
          element: 'chart',
          data: [
            {time: '2013-01-01', c: 1000},
            {time: '2013-01-02', c: 1200},
            {time: '2013-01-03', c: 1500},
          ],
          xkey: 'time',
          ykeys: ['c'],
          labels: ['example_chart'],
          xLabels: 'day',
        })
      end
    end

    context 'when monthly interval' do
      before do
        @chart = Chart.new(name: 'example_chart', type: 'uncountable')
        @stats = [
          Stat.new(time: DateTime.new(2013, 1, 1), count: 1000),
          Stat.new(time: DateTime.new(2013, 2, 1), count: 1200),
          Stat.new(time: DateTime.new(2013, 3, 1), count: 1500),
        ]
        @interval = 'monthly'
      end

      subject do
        MorrisChart.new(
          chart: @chart,
          stats: @stats,
          interval: @interval,
        ).to_hash
      end

      it 'should be correct hash' do
        should eq({
          element: 'chart',
          data: [
            {time: '2013-01', c: 1000},
            {time: '2013-02', c: 1200},
            {time: '2013-03', c: 1500},
          ],
          xkey: 'time',
          ykeys: ['c'],
          labels: ['example_chart'],
          xLabels: 'month',
        })
      end
    end
  end

  describe '#empty?' do
    subject { MorrisChart.new(chart: chart, stats: stats, interval: 'daily').empty? }
    let(:chart) { Chart.new }

    context 'stats are empty' do
      let(:stats) { [] }

      it { should be_true }
    end

    context 'stats are not empty' do
      let(:stats) { [Stat.new(time: DateTime.new(2013, 1, 1), count: 1000)] }

      it { should be_false }
    end
  end
end
