# encoding: utf-8
#require "logger"
require "open-uri"
require "mail"
require "gtk2"

Mail.defaults do
  delivery_method :smtp, {
    address: "smtp.gmail.com",
    user_name: "xinye181920",
    password: "xinye.181920",
    authentication: "plain",
  }
end

def mail_notification(msg)
  mail = Mail.deliver do
    to "13816956163@139.com"
    from "xinye181920@gmail.com"
    subject "xinye video program error!"
    text_part do
      body msg
    end
  end
  puts "notification mail sent!"
rescue => e
  puts e
end

def current_path
  File.dirname(__FILE__)
end
def download_path
  File.join(File.dirname(__FILE__),"downloads")
end

def video_in_folder
  video_path = Dir.glob(File.join(download_path,"*")).first
  if video_path
    video_path.split("/").last
  else
    nil
  end
end

def net_connected?
  loop do
    break if open("http://www.xinyegroup.com/dalaoju.html")
    system "zenity --error --text='网络连接异常！'"
    sleep 3
    system "killall zenity"
  end
  true
rescue => e
  puts e
  mail_notification e.to_s
end

def clean_old_files(new_video_name)
  puts "clean all old files"
  Dir.glob(File.join(download_path,"*")).each do |f|
    unless f.split("/").last == new_video_name
      puts "deleted file: #{f}" if File.delete f
    end
  end
rescue => e
  puts e
  mail_notification e.to_s
end

def play_video(video)
  #system "mplayer -fs -loop 0 #{video} &"
  system "vlc -fL --no-video-title-show #{video} &"
rescue => e
  puts e
  mail_notification e.to_s
end

def new_video
  if net_connected?
    video_url = open("http://www.xinyegroup.com/dalaoju.html").read.strip
    video_name = video_url.split("/").last
    if video_name == video_in_folder then
      return false
    else
      return video_url
    end
  end
rescue => e
  puts e
  mail_notification e.to_s
end

play_video File.join(download_path,video_in_folder) if video_in_folder

loop do
  begin
  puts "检查是否有更新--->"
  if video_path = new_video
    puts "updated..."
    system "zenity --info --text='找到视频，正在努力下载，请确保网络正常...' &"
    download = system "wget -c --directory-prefix=#{download_path} #{video_path}"
    if download then
      clean_old_files video_path.strip.split("/").last
      system "killall zenity"
      #system "killall mplayer"
      system "killall vlc"
      play_video File.join(download_path,video_in_folder) if video_in_folder
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


