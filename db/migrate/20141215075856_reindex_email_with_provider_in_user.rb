class ReindexEmailWithProviderInUser < ActiveRecord::Migration
  def self.up
    remove_index :users, :email
    add_index :users, [:email, :provider], unique: true
  end

  def self.down
    remove_index :users, [:email, :provider]
    add_index :users, :email, unique: true
  end
end
