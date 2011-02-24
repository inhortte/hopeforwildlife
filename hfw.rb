require 'rubygems'
%w(sinatra rack-flash datamapper dm-mysql-adapter haml sass logger bluecloth).each { |gem| require gem }
Dir.entries('./helpers').each do |helper|
  require File.join('./helpers', helper) if helper =~ /.rb$/
end
# %w(user.rb entry.rb).each { |model| require "server_models/lib/#{model}" }

require 'sinatra/reloader' if development?

set :sessions, true
set :show_exceptions, false
use Rack::Flash
use Rack::MethodOverride

configure do
  set :app_file, __FILE__
  set :root, File.dirname(__FILE__)
  set :static, :true
  set :public, Proc.new { File.join(root, "public") }
  LOGGER = Logger.new("hfw.log")
end

# DataMapper.setup(:default, 'mysql://localhost/hfw')

Dir.entries('./helpers').each do |helper|
  m = /^(.+)\.rb$/.match(helper)
  if m
    eval("helpers Sinatra::#{m[1].capitalize + 'Helper'}")
  end
end

before do
  if request.path =~ %r{/pages}
    @menus = get_menus(File.join(root, "views/pages"))
    if request.path !~ %r{/pages/home$}
      @photos = get_random_photos 3, File.basename(request.path)
    end
    if request.path =~ %r{newsletter}
      @newsletters = get_newsletters
    end
  end
end

# The routes!

get '/hfw.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :"sass/hfw"
end
  
get '/' do
  redirect '/pages/home'
end

get '/pages/:which' do
  @page = params[:which]
  @submenus = immediate_submenus(@menus, @page)
  haml :"pages/#{@page}"
end

get '/pages/:first/:second' do
  @page = params[:second]
  @submenus = immediate_submenus(@menus, @page)
  haml :"pages/#{params[:first]}/#{@page}"
end

get '/pages/:first/:second/:third' do
  @page = params[:third]
  @submenus = immediate_submenus(@menus, @page)
  haml :"pages/#{params[:first]}/#{params[:second]}/#{@page}"
end
