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

      Connection.create!(requestor: @user1, receiver: @user2, status: Connection::Status[:accepted])
      Connection.create!(requestor: @user1, receiver: @user3, status: Connection::Status[:pending])
    end

    describe '#connected users' do
      it 'returns a list of connected users' do
        expect(@user1.connected_users).to eq([@user2])
        expect(@user2.connected_users).to eq([@user1])
      end
    end

    describe '#incoming connections' do
      it 'returns a list of a users incoming connection requests' do
        expect(@user3.incoming_connections).to eq([@user1])
      end
    end

    describe '#pending connections' do
      it 'returns a list of a users pending outgoing connections' do
        expect(@user1.pending_connections).to eq([@user3])
      end
    end

    describe '#users_not_connected_broad' do
      it 'returns a list of users not connected including users with pending requests' do
        expect(@user2.users_not_connected_broad).to eq([@user3])
        expect(@user3.users_not_connected_broad).to include(@user2, @user1)
        expect(@user1.users_not_connected_broad).to eq([@user3])
      end
    end

    describe '#users_not_connected_strict' do
      it 'returns a list of users not connected exluding users with pending requests' do
        expect(@user2.users_not_connected_strict).to eq([@user3])
        expect(@user3.users_not_connected_strict).to eq([@user2])
        expect(@user1.users_not_connected_strict).to eq([])
      end
    end
  end
end
