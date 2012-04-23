# encoding: utf-8
#require "logger"
require "open-uri"
require "mail"
require "gtk2"

Mail.defaults do
  delivery_method :smtp, {
    #address: "smtp.139.com",
    address: "smtp.gmail.com",
    #user_name: "13816956163@139.com",
    user_name: "as181920",
    password: "google.181920",
    authentication: "plain",
  }
end

def mail_notification(msg)
  mail = Mail.deliver do
    to "13816956163@139.com"
    from "as181920@gmail.com"
    subject "xinye video program error!"
    text_part do
      body msg
    end
  end
  puts "notification mail sent!"
rescue => e
  puts e
end

def net_connected?
  begin
    true if open("http://www.xinyegroup.com/dalaoju.html")
  rescue => e
    puts e
    mail_notification e.to_s
  end
end

def clean_old_files
  puts "clean all old files"
  Dir.glob("*").each do |f|
    system "rm -rf #{f}" unless f == "fetch_and_play_video.rb"
  end
end

$last_video = nil
$current_video = nil

clean_old_files

loop do
  begin
    if net_connected?
      puts video_path = open("http://www.xinyegroup.com/dalaoju.html").read
      #puts video_path = "http://younoter.com/assets/rails.png"
      puts $current_video = video_name = video_path.strip.split("/").last
      if $last_video and $current_video == $last_video
        puts "无更新."
      else
        puts "已更新."
        system "rm -rf #{$last_video}"
        system "zenity --info --text='找到视频，正在努力下载，请确保网络正常...' &"
        download = system "wget -c #{video_path}"
        system "killall zenity"
        if download then
          $last_video = $current_video
          system "killall mplayer"
          system "mplayer -fs -loop 0 #{video_name} &"
        else
          puts "error"
          raise "restart mplayer error!"
        end
      end
    else
      #system "xmessage 网络连接异常... -timeout 3"
      system "zenity --error --text='网络连接异常...' --timeout=3"
    end
  rescue => e
    puts e
    mail_notification e.to_s
  end
  sleep 3
  puts "检查是否有更新--->"
end
