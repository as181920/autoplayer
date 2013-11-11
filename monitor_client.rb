# encoding: utf-8
require "open-uri"
require "net/http"
require "yaml"

def location
  YAML.load(File.read(File.join(File.dirname(__FILE__),"config/location.yml")))["loc"]
rescue => e
  return e
end

def video_in_folder
  video_path = Dir.glob(File.join(File.dirname(__FILE__),"/downloads/*")).first
  if video_path
    video_path.split("/").last
  else
    nil
  end
rescue => e
  return e
end

def internet_ip
  (open('http://checkip.dyndns.org/').read.scan(/(\d+\.\d+\.\d+\.\d+)/))[0][0]
rescue => e
  return e
end

def video_on_net
  open("http://www.xinyegroup.com/dalaoju/s.aspx?id=#{location}").read.strip
rescue => e
  return e
end

def process
  %x[ps aux|grep vlc|grep down] + %x[ps aux|grep ruby|grep rb]
rescue => e
  return e
end

def performance
  %x[uptime] +"\n"+ %x[iostat] + %x[free -ml] + %x[sensors]
rescue => e
  return e
end

loop do
  begin
    print "."
    status = {location: location, ip: internet_ip, video_in_folder: video_in_folder, video_on_net: video_on_net, performance: performance, process: process}
    #Net::HTTP.post_form URI.parse("http://www.younoter.com:82/dalaoju"), status
    Net::HTTP.post_form URI.parse("http://dlj.notes18.com:82/dalaoju"), status
  rescue => e
    puts e
    sleep 60
  end
  sleep 300
end
