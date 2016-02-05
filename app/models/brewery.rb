class Brewery < ActiveRecord::Base
 has_many :beers, dependent: :destroy
 has_many :ratings, through: :beers

 validate :year_between_1042_and_this_year
 validates :name, presence: true
 #validates :year, numericality: { greater_than_or_equal_to: 1042,
 #                                   less_than_or_equal_to: 2016,
 #                                   only_integer: true } 

 


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
 
  def year_between_1042_and_this_year
    if year < 1042 
      errors.add(:year, "can't be before 1042.")
    end
    if year > Date.today.year
      errors.add(:year, "can't be after this year.")	
    end
  end
 
 # def average_rating
 #   self.ratings.average(:score)	
 # end
end
