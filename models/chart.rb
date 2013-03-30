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

  def morris_chart(params = {})
    if countable?
      stats = Stat.all(chart_id: id, interval: default_interval)
    else
      stats = Stat.all(chart_id: id, interval: params[:interval])
    end

    MorrisChart.new(
      chart: self,
      stats: stats,
      interval: params[:interval] || default_interval,
    )
  end
end
