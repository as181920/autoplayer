# encoding: utf-8

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

