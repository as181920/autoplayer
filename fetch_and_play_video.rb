# encoding: utf-8
#require "logger"
require "open-uri"
require "mail"
require "gtk2"

include "notify_mail"

current_path = File.dirname(__FILE__)

def video_in_folder(path)
  Dir.glob(File.join(current_path,"*")).first.split("/").last
end

def net_connected?
  true if open("http://www.xinyegroup.com/dalaoju.html")
rescue => e
  puts e
  mail_notification e.to_s
end

def clean_old_files
  puts "clean all old files"
  Dir.glob(File.join(current_path,"*")).each do |f|
    puts "deleted file: #{f}" if File.delete f
  end
rescue => e
  puts e
  mail_notification e.to_s
end

def play_video(video)
  system "mplayer -fs -loop 0 #{video} &"
rescue => e
  puts e
  mail_notification e.to_s
end

def new_video
  loop do
    if net_connected?
      break
    else
      system "zenity --error --text='网络连接异常！'"
    end
  end
  video_url = open("http://www.xinyegroup.com/dalaoju.html").read.strip
  video_name = video_url.split("/").last
  if video_name == video_in_folder then
    false
  else
    video_url
  end
rescue => e
  puts e
  mail_notification e.to_s
end

play_video File.join(current_path,"downloads",video_in_folder)

loop do
  begin
  puts "检查是否有更新--->"
  if video_path = new_video
    puts "updated..."
    system "zenity --info --text='找到视频，正在努力下载，请确保网络正常...' &"
    clean_old_files
    download = system "wget -c #{video_path}"
    if download then
      system "killall zenity"
      system "killall mplayer"
      system "mplayer -fs -loop 0 #{video_in_folder} &"
    else
      puts "download error!"
      raise "download error!"
    end
  else
    puts "no update."
  end
  sleep 3
  rescue => e
    puts e
    mail_notification e.to_s
    sleep 30
  end
end


