class AddLastmodifiedToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :last_modified, :datetime
  end
end
