class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :content
      t.string :location
      t.float :lat
      t.float :lng
      t.string :treatment
      t.string :type
      t.string :worktime
      t.string :leavesys
      t.string :availability
      t.string :reqnum
      t.string :acceptid
      t.string :exp
      t.string :education
      t.string :department
      t.string :language
      t.string :tool
      t.string :skill
      t.string :othercond
      t.string :contact
      t.string :emailsrc
      t.string :inperson
      t.string :telesrc
      t.string :other

      t.timestamps
    end
  end
end
