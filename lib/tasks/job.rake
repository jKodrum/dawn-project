namespace :job do
  task :parse104 => :environment do
    desc "parse104, test for now"
    require 'open-uri'

    # Get URLs
    urls = get_urls
    @jobs = []
    urls.each do |url|
      @jobs << parse_104_web(url)
    end
    puts "Parse it! Yo!!"
  end

  def getjobs
    @jobs.each do |h|
      h.each do |key, value|
        puts key.to_s + " : " + value.to_s
      end
      puts ""
    end
  end

  def get_urls
    base_url = "http://www.104.com.tw" 
    urls = []
    (2..2).each do |page|
      raw_html = open("http://www.104.com.tw/area/volunteer/volunteer.cfm?page=#{page}").read
      # find_all <td align="left">
      narrowed_html = raw_html.scan(/<td align=\"left\"><a.*/)
      narrowed_html.each do |part|
        m = part.match( %r{href="(/jobbank/cust_job/job\S+)} )
        if m
          url = ""
          url << base_url << m[1]
          urls << url
        end
      end #narrowed_html loop
    end #page loop
    return urls
  end

  def parse_104_web(url)
    raw_html = open(url).read
    # remove \r
    raw_html.gsub! /\r/, ""
    raw_html.force_encoding("utf-8")
    # modifier "m" means allowing dot to match multiple lines
    narrowed_html = raw_html.scan(%r{(<div class=\"(?:intro|interview)\">(?:.(?!<script type|<div class=\"(?:intro|interview)))*)}m)
    essence = ""
    narrowed_html.each do |part|
      part[0].gsub!(/<br>/, "NEWLINE")
      # remove html tag, space character, statements begin with '#', and "地圖" after address
      essence << part[0].gsub(/<[^>]*>|[ \t]+|#.*|地圖/, "")
    end
    # remove blank line
    essence.gsub!(/\n+/, "\n")
    essence.gsub! /&nbsp;/, " "
    #f = File.open("essence", "r")
    #essence = f.read

    detail = [ [ "last_modified", "更新:" , /更新日期：([\d-]+)/ ],
            [ "title", "志工服務:", /comp_name\">\s\s\s<h1>([^<\t]+)/ ],
            [ "joburl", "服務網址:", "" ],
            [ "content", "工作內容:", /工作內容\n(.*)/ ],
            [ "treatment", "工作待遇:", /工作待遇：\n(.*)/ ],
            [ "jobtype", "工作性質:", /工作性質：\n(.*)/ ],
            [ "location", "上班地點:", /上班地點：\n(.*)/ ],
            [ "worktime", "上班時段:", /上班時段：\n(.*)/ ],
            [ "leavesys", "休假制度:", /休假制度：\n(.*)/ ],
            [ "availability", "可上班日:", /可上班日：\n(.*)/ ],
            [ "reqnum", "需求人數:", /需求人數：\n(.*)/ ],
            [ "acceptid", "接受身份:", /接受身份：\n(.*)/ ],
            [ "exp", "工作經歷:", /工作經歷：\n(.*)/ ],
            [ "education", "學歷要求:", /學歷要求：\n(.*)/ ],
            [ "department", "科系要求:", /科系要求：\n(.*)/ ],
            [ "language", "語文條件:", /語文條件：\n(.*)/ ],
            [ "tool", "擅長工具:", /擅長工具：\n(.*)/ ],
            [ "skill", "工作技能:", /工作技能：\n(.*)/ ],
            [ "othercond", "其他條件:", /其他條件：\n(.*)/ ],
            [ "contact", "聯絡人:", /聯 絡 人：\n(.*)/ ],
            [ "emailsrc", "Email:", /E-mail：\nfun_flash_output\(\"([^\"]+)/ ],
            [ "inperson", "親洽:", /親　　洽：\n(.*)/ ],
            [ "telesrc", "電洽:", /電　　洽：(.*\n.*)/ ],
            [ "other", "其它:", /其　　他：(.*)/ ]]
    essence.force_encoding("utf-8")
    job_hash = {}
    detail.each do |item|
      # parse each item by it's re ptn individually
      if item[0].include? "title"
        m = raw_html.match(item[2])
      elsif item[0].include? "telesrc"
        teletmp = raw_html.scan(item[2])
        if teletmp
          m = teletmp[0][0].match(/src='([^']+)/)
        end
      else
        m = essence.match(item[2])
      end

      # store the matched data
      if m && m[1]
        if item[0].include? "content"
          job_hash[ item[0] ] = m[1].gsub(/NEWLINE/, "\n")
        else
          job_hash[ item[0] ] = m[1]
        end
      elsif item[0].include? "joburl"
        job_hash[ item[0] ] = url
      else
        job_hash[ item[0] ] = ""
      end
    end
    return job_hash
  end

  
  task :py_insert_jobs => :environment do
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

end
