module ConnectionsModule
  def connected_users
    connections = requestor_connections.accepted + receiver_connections.accepted

    user_ids = connections.map do |c|
      c.receiver_id == id ? c.requestor_id : c.receiver_id
    end

    User.where(id: user_ids).where.not(id: id)
  end

  def incoming_connections
    connection_ids = receiver_connections.pending.pluck(:requestor_id)

    User.where(id: connection_ids).where.not(id: id)
  end

  def pending_connections
    connection_ids = requestor_connections.pending.pluck(:receiver_id)

    User.where(id: connection_ids)
  end

  def users_not_connected_broad
    ids = (connected_users).pluck(:id)
    User.where.not(id: ids).where.not(id: id)
  end

  def users_not_connected_strict
    ids = (connected_users + incoming_connections + pending_connections).pluck(:id)
    User.where.not(id: ids).where.not(id: id)
  end
end
