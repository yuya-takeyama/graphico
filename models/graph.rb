class Graph
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String, :unique_index => :service_section_name, :required => true
  property :screen_name, String
  property :service_name, String, :unique_index => :service_section_name, :required => true
  property :section_name, String, :unique_index => :service_section_name, :required => true
  property :default_interval, String, :required => true

  timestamps :at
  property :deleted_at, ParanoidDateTime
end
