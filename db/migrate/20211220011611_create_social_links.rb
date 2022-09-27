class CreateSocialLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :social_links do |t|
      t.integer 'user_id'
      t.integer 'type'
      t.string 'url'
      t.timestamps
    end
  end
end
