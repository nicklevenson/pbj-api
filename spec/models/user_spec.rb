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
    describe '#connected users' do
    end

    describe '#incoming connections' do
    end

    describe '#pending connections' do
    end
  end
end
