class Beer < ActiveRecord::Base
 belongs_to :brewery
 belongs_to :style
 has_many :ratings, dependent: :destroy
 has_many :raters, through: :ratings, source: :user
 
 validates :name, presence: true
 #validates :style, presence: true

 include RatingAverage
# def average_rating
#   self.ratings.average(:score)
# end

 def to_s
   "#{name}, #{brewery.name}"
 end
 
 def average
    return 0 if ratings.empty?
    ratings.map{ |r| r.score }.sum / ratings.count.to_f
 end

 def self.top(n)
   sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating||0) }
   # palauta listalta parhaat n kappaletta
   return sorted_by_rating_in_desc_order.first(n)
 end 	   
end
