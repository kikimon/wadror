class Beer < ActiveRecord::Base
 belongs_to :brewery
 has_many :ratings, dependent: :destroy
 
 include RatingAverage
# def average_rating
#   self.ratings.average(:score)
# end

 def to_s
   "#{name}, #{brewery.name}"
 end  	   
end
