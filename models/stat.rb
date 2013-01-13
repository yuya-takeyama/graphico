class Stat
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :graph_id, Integer
  property :time, DateTime
  property :count, Integer
  property :created_at, DateTime
  property :updated_at, DateTime
end
