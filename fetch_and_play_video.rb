# encoding: utf-8
#require "logger"
require "open-uri"
require "mail"

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
end

$last_video = nil
$current_video = nil

loop do
  begin
    #video_path = open("/ljasdjfjadsf").read.scan
    puts video_path = "http://younoter.com/assets/rails.png"
    puts $current_video = video_name = video_path.strip.split("/").last
    if $last_video and $current_video == $last_video
      puts "无更新."
    else
      puts "已更新."
      system "rm -rf #{$last_video}"
      download = system "wget -p #{video_path}"
      if download then
        $last_video = $current_video
        system "killall qiv"
        system "qiv #{video_name} &"
      else
        puts "error"
        raise "restart mplayer error!"
      end
    end
  rescue => e
    puts e
    mail_notification e
  end
  sleep 3
  puts "检查是否有更新--->"
end

def clean_old_files
  Dir.glob("*").each do |f|
    system "rm -rf #{f}" unless if == "fetch_and_play_video.rb"
  end
end
