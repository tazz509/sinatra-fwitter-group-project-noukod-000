require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    set :session_secret,"secret"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  helpers do
      def logged_in?
        !session[:user_id].nil?
      end

      def current_user
        User.find_by_id(session[:user_id])
      end
  end

  get "/" do
    erb :"index"
  end

  get "/login" do
    if logged_in?
      redirect "/tweets"
    else
      erb :"users/login"
    end
  end

  post "/login" do
    # binding.pry
    user = User.find_by(:username => @params[:user][:username])

   if user && user.authenticate(@params[:user][:password])
     session[:user_id] = user.id
     redirect("/tweets")
   else
     redirect("/")
   end
  end

  get "/signup" do

    if !logged_in?
      erb :"users/create_user"
    else
      redirect "/tweets"
    end
  end

  post "/signup" do

    @user=User.create(params[:user])
    if @user.valid?
      session[:user_id]=@user.id
      redirect "/tweets"
    else
      redirect "/signup"
    end

  end

  get "/logout" do
    if logged_in?
      session.clear
      redirect "/login"
    else
      redirect "/"
    end
  end

end
