class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string "username"
      t.string "email"
      t.string "photo"
      t.string "location", default: "Earth"
      t.text "bio"
      t.string "uid"
      t.string "provider"
      t.string "providerImage", default: "https://icon-library.net//images/no-user-image-icon/no-user-image-icon-27.jpg"
      t.string "token"
      t.string "refresh_token"
      t.decimal "lng", precision: 10, scale: 6
      t.decimal "lat", precision: 10, scale: 6
      t.boolean "email_subscribe", default: true
      t.integer "login_count", default: 0

      t.timestamps
    end
  end
end
