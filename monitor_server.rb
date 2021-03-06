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
  @per_page = 20
  @logs = Coll.find.sort(["created_at","descending"]).skip([(params[:page].to_i-1)*@per_page,0].max).limit(@per_page)
  erb :log, locals: {page: params[:page], logs: @logs} 
end

get "/dlj" do
  @per_page = 50
  @logs = Coll.find.sort(["created_at","descending"]).skip([(params[:page].to_i-1)*@per_page,0].max).limit(@per_page)
  erb :dlj, locals: {page: params[:page], logs: @logs} 
end

get "/dl" do
  @per_page = 100
  @logs = Coll.find.sort(["created_at","descending"]).skip([(params[:page].to_i-1)*@per_page,0].max).limit(@per_page)
  erb :dl, locals: {page: params[:page], logs: @logs} 
end

post "/dalaoju" do
  params[:created_at] = Time.now
  Coll.insert params
  "successfully logged @#{Time.now}"
end

private


