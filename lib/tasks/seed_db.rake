if Rails.env.development?
  task seed_db: :environment do
    5000.times do
      params = {
        email: Faker::Internet.unique.email,
        username: Faker::Name.unique.name,
        location: Faker::Address.city,
        lat: Faker::Address.latitude,
        lng: Faker::Address.longitude,
        bio: Faker::Quote.famous_last_words
      }

      user = User.find_or_create_by(params)

      2.times do
        tag = Tag.find_or_create_by(kind: 0, name: Faker::Music.band)
        user.tags << tag
      end

      2.times do
        tag = Tag.find_or_create_by(kind: 1, name: Faker::Music.genre)
        user.tags << tag
      end

      2.times do
        tag = Tag.find_or_create_by(kind: 2, name: Faker::Music.instrument)
        user.tags << tag
      end

      user.save
    end
  end
end
