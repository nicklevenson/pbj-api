# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
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
#  email_subscribe :boolean          default(TRUE)
#  login_count     :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  incognito       :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'connection module' do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)

      Connection.create!(requestor: @user1, receiver: @user2, status: Connection::STATUS[:accepted])
      Connection.create!(requestor: @user1, receiver: @user3, status: Connection::STATUS[:pending])
    end

    describe '#connected_users' do
      it 'returns a list of connected users' do
        expect(@user1.connected_users).to eq([@user2])
        expect(@user2.connected_users).to eq([@user1])
      end
    end

    describe '#incoming_connections' do
      it 'returns a list of a users incoming connection requests' do
        expect(@user3.incoming_connections).to eq([@user1])
      end
    end

    describe '#pending_connections' do
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

    describe 'request, accept, reject' do
      before do
        Connection.all.destroy_all
        @user1.request_connection(@user2.id)
      end

      describe '#request_connection' do
        it 'requests a connection to another user' do
          expect(@user2.incoming_connections).to eq([@user1])
          expect(@user1.pending_connections).to eq([@user2])
        end

        it 'creates a notification for the receiving user' do
          expect(@user2.notifications.first).to have_attributes(content: 'has requested to connect with you',
                                                                involved_user_id: @user1.id)
        end
      end

      describe '#accept_incoming_connection' do
        before do
          @user2.accept_incoming_connection(@user1.id)
        end

        it 'accepts an incoming connection' do
          expect(@user2.connected_users).to eq([@user1])
          expect(@user1.connected_users).to eq([@user2])
        end

        it 'creates a notification for the requesting user' do
          expect(@user1.notifications.first).to have_attributes(content: 'has accepted your connection request',
                                                                involved_user_id: @user2.id)
        end
      end

      describe '#reject_incoming_connection' do
        it 'rejects an incoming request' do
          @user2.reject_incoming_connection(@user1.id)

          expect(@user2.rejected_connections).to eq([@user1])
          expect(@user2.user_feed).to eq([@user3])
        end
      end
    end
  end
end
