class AddJoburlToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :joburl, :string
  end
end
