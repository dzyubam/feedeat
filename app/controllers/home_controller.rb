require 'open-uri'
require 'cgi'
require 'digest/sha1'

class HomeController < ApplicationController

  http_basic_authenticate_with name: "max", password: "maxmax", except: [:index, :show]

  def index
    if params[:query].present?
      @articles = Article.search(params[:query])
    else
      @articles = Article.order("updated_at DESC").to_a
    end
  end

  def show
    @article_single = Article.find(params[:id])
  end

  def parse
    @rss = params[:rss]
    if @rss =~ URI::regexp #is this a URL?
      rssParser = SimpleRSS.parse open(@rss)
      @rssItems = rssParser.items
    end
  end

  def import
    @rss = params[:rss] ? params[:rss] : Feed.find(params[:feed_id]).url

    #@rss = Feed.find(params[:feed_id])
    if @rss =~ URI::regexp #is this a URL?
      rssParser = SimpleRSS.parse open(@rss)
      @rssItems = rssParser.items

      @rssItems.each do |item|
        # check if the article with the same title and description was already imported
        @computed_hash = Digest::SHA1.hexdigest(item.title.to_s + item.description.to_s)
        @article_exists = Article.find_by(unique_hash: @computed_hash)

        unless @article_exists
          if params[:feed_id]
            @saved_item = Feed.find(params[:feed_id]).articles.new(:title => item.title,
                                                                   :body => CGI.unescapeHTML(item.description),
                                                                   :rss_url => item.link,
                                                                   :unique_hash => @computed_hash)
          else
            @saved_item = Article.new(:title => item.title,
                                      :body => CGI.unescapeHTML(item.description),
                                      :rss_url => item.link,
                                      :unique_hash => @computed_hash)
          end
          unless @saved_item.save
            raise @saved_item.inspect
          end
        else
          # do something if there is an item with the same digest
          #raise @article_exists.inspect
        end
      end
    end
  end

end
