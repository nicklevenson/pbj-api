# == Schema Information
#
# Table name: connections
#
#  id           :bigint           not null, primary key
#  requestor_id :integer
#  receiver_id  :integer
#  status       :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Connection, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
