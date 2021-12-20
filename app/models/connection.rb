# == Schema Information
#
# Table name: connections
#
#  id              :integer          not null, primary key
#  connection_a_id :integer
#  connection_b_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Connection < ApplicationRecord
end
