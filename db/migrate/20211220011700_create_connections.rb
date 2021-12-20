class CreateConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :connections do |t|
      t.integer "connection_a_id"
      t.integer "connection_b_id"
      t.timestamps
    end
  end
end
