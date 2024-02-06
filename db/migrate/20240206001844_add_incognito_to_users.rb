class AddIncognitoToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :incognito, :boolean, default: false
  end
end
