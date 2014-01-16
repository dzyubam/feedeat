class Article < ActiveRecord::Base
  belongs_to :feed

  include Tire::Model::Search
  include Tire::Model::Callbacks

end
