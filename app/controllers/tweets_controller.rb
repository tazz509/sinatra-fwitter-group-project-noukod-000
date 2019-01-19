class TweetsController < ApplicationController

  get "/tweets" do
    if logged_in?
      @tweets=Tweet.all
      #binding.pry
      erb :"tweets/tweets"
    else
      redirect "/login"
    end
  end

  post "/tweets" do
    #binding.pry
    @tweet=Tweet.create({content:@params[:tweet][:content]})

    if @tweet.valid?
      current_user.tweets << @tweet
      redirect "/tweets/#{@tweet.id}"
    else
      redirect "/tweets/new"
    end
  end

  delete "/tweets/:id" do
    @tweet=Tweet.find_by_id(@params[:id])
    if @tweet.nil?
      redirect("/")
    else
      @tweet.delete
      redirect("/tweets")
    end
  end

  get "/tweets/new" do
    erb :"tweets/new"
  end

  get "/tweets/:id/edit" do
    if logged_in?
      @tweet=Tweet.find_by_id(@params[:id])

      if current_user.tweets.include?(@tweet)
        erb :"tweets/edit_tweet"
      else
        redirect "/"
      end
    end

  end

  patch "/tweets/:id" do
    @tweet=Tweet.find_by_id(@params[:id])
    @tweet.content=@params[:tweet][:content]
    @tweet.save

    redirect "/tweets/#{@params[:id]}"

  end

  get "/tweets/:id" do
    if logged_in?
      @tweet=Tweet.find_by_id(@params[:id])
      erb :"tweets/show_tweet"
    else
      redirect "/login"
    end

  end


end
