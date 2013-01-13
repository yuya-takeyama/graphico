class Graph
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :service_name, String
  property :section_name, String
  property :graph_name, String
  property :type, String
  property :created_at, DateTime
  property :updated_at, DateTime
end
