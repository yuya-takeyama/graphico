class DailyStat
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :time, Date
  property :service_name, String
  property :section_name, String
  property :graph_name, String
  property :count, Integer
end
