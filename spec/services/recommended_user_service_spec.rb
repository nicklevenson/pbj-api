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
      @user1.set_coords_and_location('Portland, OR')
      @user2.set_coords_and_location('Beaverton, OR')
      @user3.set_coords_and_location('San Diego')

      result = RecommendedUsersService.new(user: @user1, range: 10).get_recommendation

      expect(result).to eq([@user2])
    end

    it 'returns a list of recommended users based on genre filters' do
      tag = create(:tag, :genre)
      @user1.tags << tag
      @user3.tags << tag
      result = RecommendedUsersService.new(user: @user1, genres: [tag.name]).get_recommendation
      expect(result).to eq([@user3])
    end

    it 'returns a list of recommended users based on instrument filters' do
      tag = create(:tag, :instrument)
      @user1.tags << tag
      @user3.tags << tag
      result = RecommendedUsersService.new(user: @user1, instruments: [tag.name]).get_recommendation
      expect(result).to eq([@user3])
    end

    it 'combines instrument and genre filters and isnt too pointy when one does not yield result' do
      tag = create(:tag, :genre)
      @user1.tags << tag
      @user3.tags << tag

      result = RecommendedUsersService.new(user: @user1, genres: [tag.name], instruments: ['guitar']).get_recommendation
      expect(result).to eq([@user3])

      tag2 = create(:tag, :instrument)
      @user1.tags << tag2
      @user3.tags << tag2

      result = RecommendedUsersService.new(user: @user1, genres: [tag.name],
                                           instruments: [tag2.name]).get_recommendation
      expect(result).to eq([@user3])

      tag3 = create(:tag, :instrument)
      @user1.tags << tag3
      @user2.tags << tag3

      result = RecommendedUsersService.new(user: @user1, genres: [tag.name],
                                           instruments: [tag2.name, tag3.name]).get_recommendation
      expect(result).to eq([@user3, @user2])
    end

    it 'excludes users who are connected' do
      Connection.create!(requestor: @user1, receiver: @user2, status: Connection::STATUS_MAPPINGS[:accepted])

      result = RecommendedUsersService.new(user: @user1).get_recommendation

      expect(result).to eq([@user3])
    end
  end
end
