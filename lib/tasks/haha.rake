task :read => :environment do
  if file = File.open("../104crawler/rails_insert_job.txt", "r")
    txt= file.read.split("\n")
    err_cnt=0
    cnt=0
    txt.each do |s|
      begin
        #p txt
        cnt += 1
        puts cnt
        eval(s)
      rescue
        err_cnt += 1
        puts "rescue: " << err_cnt.to_s
      end
    end
    #puts txt
  else
    puts 'file not found'
  end
end

task :job => :environment do
  txt = %x(python /Users/SianJhe/programming/RoR/104crawler/104jobdet.py)
  insert_cmds = txt.split(/\n/)
  err_cnt=0
  cnt=0
  insert_cmds.each do |cmd|
    begin
      cnt += 1
      puts cnt
      eval(cmd)
    rescue
      err_cnt += 1
      puts "fails: " << err_cnt.to_s
    end
  end
end
