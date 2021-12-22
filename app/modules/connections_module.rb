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

  def rejected_connections
    connection_ids = Connection.rejected.where(receiver_id: id).pluck(:requestor_id)

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

  def request_connection(receiving_user_id)
    connection = Connection.find_by(receiver_id: receiving_user_id, requestor_id: id)

    if connection
      false
    else
      Connection.create(receiver_id: receiving_user_id, requestor_id: id)
      true
    end
  end

  def accept_incoming_connection(requesting_user_id)
    connection = Connection.find_by(receiver_id: id, requestor_id: requesting_user_id)

    if connection
      connection.update(status: Connection::STATUS_MAPPINGS[:accepted])
      true
    else
      false
    end
  end

  def reject_incoming_connection(requesting_user_id)
    connection = Connection.find_by(receiver_id: id, requestor_id: requesting_user_id)

    if connection
      connection.update(status: Connection::STATUS_MAPPINGS[:rejected])
      true
    else
      false
    end
  end
end
