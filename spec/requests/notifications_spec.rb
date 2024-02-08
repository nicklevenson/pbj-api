# == Schema Information
#
# Table name: notifications
#
#  id               :bigint           not null, primary key
#  user_id          :integer
#  content          :string
#  read             :boolean          default(FALSE)
#  involved_user_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  # describe 'GET /index' do
  #   pending "add some examples (or delete) #{__FILE__}"
  # end
end
