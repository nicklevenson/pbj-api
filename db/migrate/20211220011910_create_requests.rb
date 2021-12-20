class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.integer "requestor_id"
      t.integer "receiver_id"
      t.boolean "accepted", default: false
      t.timestamps
    end
  end
end
