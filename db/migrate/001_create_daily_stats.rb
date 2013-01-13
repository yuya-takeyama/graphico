migration 1, :create_daily_stats do
  up do
    create_table :daily_stats do
      column :id, Integer, :serial => true
      column :time, Date
      column :service_name, String, :length => 255
      column :section_name, String, :length => 255
      column :graph_name, String, :length => 255
      column :count, Integer
    end
  end

  down do
    drop_table :daily_stats
  end
end
