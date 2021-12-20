class CreateSocialLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :social_links do |t|
      t.integer "user_id"
      t.string "soundcloud_link"
      t.string "bandcamp_link"
      t.string "youtube_link"
      t.string "spotify_link"
      t.string "apple_music_link"
      t.string "instagram_link"
      t.timestamps
    end
  end
end
