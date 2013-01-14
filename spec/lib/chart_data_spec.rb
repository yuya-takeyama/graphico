require 'spec_helper'

describe 'ChartData' do
  context 'when daily interval' do
    before do
      @chart = Chart.new(name: 'example_chart')
      @stats = [
        Stat.new(time: DateTime.new(2013, 1, 1), count: 1000),
        Stat.new(time: DateTime.new(2013, 1, 2), count: 1200),
        Stat.new(time: DateTime.new(2013, 1, 3), count: 1500),
      ]
      @interval = 'daily'
    end

    subject do
      ChartData.new(
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
      })
    end
  end
end
