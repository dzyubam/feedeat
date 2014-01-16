class FeedsController < ApplicationController
  def index
    @all_feeds = Feed.all
  end

  def show
    @feed_single = Feed.find(params[:id])
  end

  def new
    @new_feed = Feed.new
  end

  def create
    @feed_exists = Feed.find_by(url: params[:url])

    unless @feed_exists
      @saved_item = Feed.new(:title => params[:title],
                             :url => params[:url]) if params[:url] =~ URI::regexp # is this a URL?
      unless @saved_item.save
        raise @saved_item.inspect
      end
      redirect_to index_path
    end
  end
end
