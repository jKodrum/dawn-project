class ReindexJoburlAsUniqueInJobs < ActiveRecord::Migration
  def self.up
    add_index :jobs, :joburl, unique: true
  end

  def self.down
    remove_index :jobs, :joburl
  end
end
