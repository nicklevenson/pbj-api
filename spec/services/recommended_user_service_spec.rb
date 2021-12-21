require 'rails_helper'

RSpec.describe RecommendedUsersService, type: :service do
  before do
    @user1 = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)
  end

  describe '#get_recommendation' do
    it 'returns a list of users eligible to connect' do
      result = RecommendedUsersService.new(user: @user1).get_recommendation

      expect(result).to eq([@user2, @user3])
    end

    it 'returns a list of recommended users based on matching tag counts' do
      tag = create(:tag)
      @user1.tags << tag
      @user3.tags << tag

      result = RecommendedUsersService.new(user: @user1).get_recommendation
      expect(result).to eq([@user3, @user2])
    end

    it 'returns a list of recommended users based on a given proximity range' do
    end

    it 'returns a list of recommended users based on genre filters' do
    end

    it 'returns a list of recommended users based on instrument filters' do
    end
  end
end
