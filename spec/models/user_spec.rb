# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  email           :string
#  photo           :string
#  location        :string           default("Earth")
#  bio             :text
#  uid             :string
#  provider        :string
#  providerImage   :string           default("https://icon-library.net//images/no-user-image-icon/no-user-image-icon-27.jpg")
#  token           :string
#  refresh_token   :string
#  lng             :decimal(10, 6)
#  lat             :decimal(10, 6)
#  email_subscribe :boolean          default("true")
#  login_count     :integer          default("0")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'connection module' do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
    end

    describe '#connected users' do
      before do
        Connection.create!(requestor: @user1, receiver: @user2, status: 1)
        Connection.create!(requestor: @user1, receiver: @user3, status: 0)
      end

      it 'returns a list of connected users' do
        expect(@user1.connected_users).to eq([@user2])
        expect(@user2.connected_users).to eq([@user1])
      end
    end

    describe '#incoming connections' do
    end

    describe '#pending connections' do
    end
  end
end
