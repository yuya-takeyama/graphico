class Chart
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String, :unique_index => :service_section_name, :required => true
  property :screen_name, String
  property :service_name, String, :unique_index => :service_section_name, :required => true
  property :section_name, String, :unique_index => :service_section_name, :required => true
  property :default_interval, String, :required => true

  timestamps :at
  property :deleted_at, ParanoidDateTime, :unique_index => :service_section_name

  def self.services
    self.all(
      fields: ['service_name'],
      unique: true
    ).map{|c| c.service_name }
  end

  def self.sections
    Chart.all(
      fields: ['service_name', 'section_name'],
      unique: true
    ).map {|c| c.section_name }
  end
end
