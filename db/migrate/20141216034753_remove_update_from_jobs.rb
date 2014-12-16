class RemoveUpdateFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :update, :datetime
  end
end
