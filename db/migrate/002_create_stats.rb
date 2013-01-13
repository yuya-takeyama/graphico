migration 2, :create_stats do
  up do
    create_table :stats do
      column :id, Integer, :serial => true
      column :graph_id, Integer
      column :time, DateTime
      column :count, Integer
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end

  down do
    drop_table :stats
  end
end
