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
  belongs_to :requestor, class_name: :User
  belongs_to :receiver, class_name: :User

  STATUS = {
    pending: 0,
    accepted: 1,
    rejected: 2,
    blocked: 3
  }.freeze

  STATUS_LOOKUP = STATUS.invert

  scope :accepted, -> { where(status: STATUS[:accepted]) }
  scope :pending, -> { where(status: STATUS[:pending]) }
  scope :rejected, -> { where(status: STATUS[:rejected]) }
  scope :blocked, -> { where(status: STATUS[:blocked]) }
end
