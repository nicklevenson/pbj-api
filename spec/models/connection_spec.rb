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

require 'rails_helper'

RSpec.describe Connection, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
