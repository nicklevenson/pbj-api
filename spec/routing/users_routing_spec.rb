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

RSpec.describe UsersController, type: :routing do
  # describe 'routing' do
  #   it 'routes to #index' do
  #     expect(get: '/users').to route_to('users#index')
  #   end

  #   it 'routes to #show' do
  #     expect(get: '/users/1').to route_to('users#show', id: '1')
  #   end

  #   it 'routes to #create' do
  #     expect(post: '/users').to route_to('users#create')
  #   end

  #   it 'routes to #update via PUT' do
  #     expect(put: '/users/1').to route_to('users#update', id: '1')
  #   end

  #   it 'routes to #update via PATCH' do
  #     expect(patch: '/users/1').to route_to('users#update', id: '1')
  #   end

  #   it 'routes to #destroy' do
  #     expect(delete: '/users/1').to route_to('users#destroy', id: '1')
  #   end
  # end
end
