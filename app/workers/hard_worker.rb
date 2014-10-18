class HardWorker
  include Sidekiq::Worker

  def perform(name, count)
    puts 'Doing hard work - #{name}'
    article = Feed.find(1).articles.new(:title => "test article - #{name}",
                              :body => "body - #{name}",
                              :rss_url => "http://google.com/",
                              :unique_hash => "no_digest")
    unless article.save
      raise article.inspect
    end

    logger.info "Things are happening. - #{name}"
  end
end