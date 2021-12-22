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

  def request_connection(user_id)
    if !connected_users.include?(User.find(user_id))
      request = Request.find_or_create_by(requestor_id: id, receiver_id: user_id)
      User.find(user_id).notifications << Notification.create(content: 'has requested to connect with you',
                                                              involved_username: username, involved_user_id: id)
      if request.save
        true
      else
        false
      end
    else
      'Already Connected'
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
