class AddUpdateToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :update, :datetime
  end
end
