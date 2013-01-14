class Stat
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :graph_id, Integer, :unique_index => :graph_interval_time, :required => true
  property :interval, String, :unique_index => :graph_interval_time, :required => true
  property :time, DateTime, :unique_index => :graph_interval_time, :required => true
  property :count, Integer, :required => true

  timestamps :at
  property :deleted_at, ParanoidDateTime
end
