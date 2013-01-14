class Stat
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :chart_id, Integer, :unique_index => :chart_interval_time, :required => true
  property :interval, String, :unique_index => :chart_interval_time, :required => true
  property :time, DateTime, :unique_index => :chart_interval_time, :required => true
  property :count, Integer, :required => true

  timestamps :at
  property :deleted_at, ParanoidDateTime, :unique_index => :chart_interval_time
end
