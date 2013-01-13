migration 1, :create_graphs do
  up do
    create_table :graphs do
      column :id, Integer, :serial => true
      column :service_name, String, :length => 255
      column :section_name, String, :length => 255
      column :graph_name, String, :length => 255
      column :type, String, :length => 255
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end

  down do
    drop_table :graphs
  end
end
