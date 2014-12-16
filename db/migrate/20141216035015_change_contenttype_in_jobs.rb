class ChangeContenttypeInJobs < ActiveRecord::Migration
  def self.up
    change_column :jobs, :content, :text
  end
  def self.down
    change_column :jobs, :content, :string
  end
end
