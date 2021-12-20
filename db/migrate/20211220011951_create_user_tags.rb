class CreateUserTags < ActiveRecord::Migration[7.0]
  def change
    create_table :user_tags do |t|

      t.timestamps
    end
  end
end
