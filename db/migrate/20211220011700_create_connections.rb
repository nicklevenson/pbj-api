class CreateConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :connections do |t|
      t.integer 'requestor_id'
      t.integer 'receiver_id'
      t.integer 'status', default: 0
      t.timestamps
    end
  end
end
