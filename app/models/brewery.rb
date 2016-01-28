class Brewery < ActiveRecord::Base
 has_many :beers, dependent: :destroy
 has_many :ratings, through: :beers

 include RatingAverage

 def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
 end

 def restart
    self.year = 2016
    puts "changed year to #{year}"
 end

 # def average_rating
 #   self.ratings.average(:score)	
 # end
end