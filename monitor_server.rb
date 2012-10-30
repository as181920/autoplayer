# encoding: utf-8
require "sinatra"
require "mongo"

MongoConn = Mongo::Connection.new "localhost", 27017
DB = MongoConn.db "uplayer"
Coll = DB.collection "status"

get "/" do
  "<br/> <br/> <br/> 私人领地，闲人莫入！ <br/><br/> <br/> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ------Andersen Fan(as181920@hotmail.com)"
end


get "/dalaoju" do
  @logs = Coll.find.sort(["created_at","descending"]).skip([(params[:page].to_i-1)*10,0].max).limit(20)
  @cnt_pages = (Coll.find.count.to_f / 10).ceil
  erb :log, locals: {page: params[:page], cnt_pages: @cnt_pages, logs: @logs} 
end

get "/dlj" do
  @logs = Coll.find.sort(["created_at","descending"]).skip([(params[:page].to_i-1)*10,0].max).limit(20)
  @cnt_pages = (Coll.find.count.to_f / 10).ceil
  erb :dlj, locals: {page: params[:page], cnt_pages: @cnt_pages, logs: @logs} 
end

post "/dalaoju" do
  params[:created_at] = Time.now
  Coll.insert params
  "successfully logged @#{Time.now}"
end

private


