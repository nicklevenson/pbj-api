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
      Connection.create!(receiver_id: receiving_user_id, requestor_id: id)
      request_notification(receiving_user_id)
      true
    end
  end

  def accept_incoming_connection(requesting_user_id)
    connection = Connection.find_by(receiver_id: id, requestor_id: requesting_user_id)

    if connection
      connection.update(status: Connection::STATUS[:accepted])
      accepted_notification(requesting_user_id)
      create_chatroom(requesting_user_id)
      true
    else
      false
    end
  end

  def reject_incoming_connection(requesting_user_id)
    connection = Connection.find_by(receiver_id: id, requestor_id: requesting_user_id)

    if connection
      connection.update(status: Connection::STATUS[:rejected])
      true
    else
      false
    end
  end

  def similar_tags(user_id)
    other_user = User.find(user_id)
    (tags & other_user.tags).pluck(:name)
  end

  private

  def request_notification(receiving_user_id)
    Notification.create!(content: 'has sent you a connection request', involved_user_id: id, user_id: receiving_user_id)
  end

  def accepted_notification(requesting_user_id)
    requested_user = User.find(requesting_user_id)
    Notification.create!(content: 'has accepted your connection request', involved_user_id: id, user_id: requesting_user_id)
  end

  def create_chatroom(requesting_user_id)
    requested_user = User.find(requesting_user_id)
    chatroom = chatrooms.new
    chatroom.users << self
    chatroom.users << requested_user
    chatroom.save!    
  end
end
