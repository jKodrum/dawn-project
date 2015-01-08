class AddImageLargeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :image_large, :string, default: "profile-icon.png"
  end
end
