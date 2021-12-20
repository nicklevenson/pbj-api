# == Schema Information
#
# Table name: connections
#
#  id           :integer          not null, primary key
#  requestor_id :integer
#  receiver_id  :integer
#  status       :integer          default("0")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Connection < ApplicationRecord
  belongs_to :requestor_id, class_name: :User
  belongs_to :receiver_id, class_name: :User

  STATUS_MAPPINGS = {
    pending: 0,
    accepted: 1, 
    rejected: 2, 
    blocked: 3
  }.freeze

  STATUS_LOOKUP = STATUS_MAPPINGS.invert
end
