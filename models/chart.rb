class Chart
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String, :unique_index => :service_section_name, :required => true
  property :screen_name, String
  property :service_name, String, :unique_index => :service_section_name, :required => true
  property :section_name, String, :unique_index => :service_section_name, :required => true
  property :type, String, :required => true
  property :default_interval, String, :required => true

  timestamps :at
  property :deleted_at, ParanoidDateTime, :unique_index => :service_section_name

  def self.services
    self.all(
      fields: ['service_name'],
      unique: true,
      order: 'service_name'
    ).map{|c| c.service_name }
  end

  def self.sections(conditions = {})
    conditions = {
      fields: ['service_name', 'section_name'],
      unique: true,
      order: 'section_name'
    }.merge(conditions)


    Chart.all(conditions).map {|c| c.section_name }
  end

  def countable?
    type == 'countable'
  end

  def uncountable?
    type == 'uncountable'
  end

  def gauge?
    type == 'gauge'
  end

  def morris_chart(params = {})
    interval = params[:interval] || default_interval

    if gauge?
      filter = case interval
      when 'daily'
        lambda {|stat| time = stat.time; time.hour == 0 and time.minute == 0 and time.second == 0 }
      when 'monthly'
        lambda {|stat| time = stat.time; time.day == 1 and time.hour == 0 and time.minute == 0 and time.second == 0 }
      end

      stats = Stat.all(chart_id: id, interval: 'momentary').select(&filter).to_a
    elsif countable?
      stats = Stat.all(chart_id: id, interval: default_interval)
    else
      stats = Stat.all(chart_id: id, interval: interval)
    end

    MorrisChart.new(
      chart: self,
      stats: stats,
      interval: interval,
      element: css_id,
    )
  end

  def render_morris_chart(params = {})
    <<-EOS
<div id='#{css_id}'></div>
<script>
Morris.Line(#{morris_chart(params).to_json})
</script>

    EOS
  end

  def morris_chart_empty?(params = {})
    morris_chart(params).empty?
  end

  def css_id
    "chart_#{id}"
  end
end
