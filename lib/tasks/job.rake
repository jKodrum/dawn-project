task :job => :environment do
  desc "insert jobs through 104jobdet.py, write log to /insert_log.txt"
  # open a file to records logs
  log = File.open(%x(printf $HOME) << "/programming/RoR/project/insert_log.txt", "w")
  log.puts Time.now.strftime("%m/%d %a %R, %Y")
  # execute python to get job data
  txt = %x(python ${HOME}/programming/RoR/104crawler/104jobdet.py)
  insert_cmds = txt.split(/\n/)
  cnt=0
  suc_cnt=0
  err_cnt=0
  # insert data into database
  insert_cmds.each do |cmd|
    begin
      cnt += 1
      log.write cnt
      eval(cmd)
    rescue
      err_cnt += 1
      log.write " FAIL (duplicated): " << err_cnt.to_s
    else
      suc_cnt += 1
      log.write " Success: " << suc_cnt.to_s
    ensure
      log.puts
    end
  end
  log.puts "END insertion"
  log.puts
  log.close
end
