# == Schema Information
#
# Table name: requests
#
#  id           :integer          not null, primary key
#  requestor_id :integer
#  receiver_id  :integer
#  accepted     :boolean          default("false")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Request < ApplicationRecord
end
