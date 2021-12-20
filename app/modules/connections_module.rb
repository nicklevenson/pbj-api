module ConnectionsModule
  def connected_users
    connections = requestor_connections.accepted + receiver_connections.accepted

    user_ids = connections.map do |c|
      c.receiver_id == id ? c.requestor_id : c.receiver_id
    end

    User.where(id: user_ids)
  end

  def incoming_connections
    connection_ids = receiver_connections.pending.pluck(:requestor_id)

    User.where(id: connection_ids)
  end

  def pending_connections
    connection_ids = requestor_connections.pending.pluck(:receiver_id)

    User.where(id: connection_ids)
  end
end
