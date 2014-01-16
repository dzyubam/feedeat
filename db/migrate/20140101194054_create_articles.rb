class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.string :rss_url
      t.string :unique_hash
      t.references :feed, index: true

      t.timestamps
    end
  end
end
