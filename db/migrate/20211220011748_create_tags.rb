class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.integer 'kind', default: 0
      t.string 'name'
      t.string 'image_url'
      t.string 'link'
      t.string 'uri'
      t.timestamps
    end
  end
end
