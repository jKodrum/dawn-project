class ChangeImageOnUser < ActiveRecord::Migration
  def self.up
    change_column :users, :image, :string, default: "profile-icon.png"
  end

  def self.down
    change_column :users, :image, :string
  end
end
