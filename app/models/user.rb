class User < ActiveRecord::Base
   
   include RatingAverage
   
   has_secure_password
   has_many :ratings, dependent: :destroy  # käyttäjällä on monta ratingia
   has_many :memberships, dependent: :destroy
   has_many :beers, through: :ratings
   has_many :beer_clubs, through: :memberships

   validate :validate_password
 

   validates :username, uniqueness: true,
                        length: { minimum: 3, maximum: 15 }   

   #validates :password, length: { minimum: 4 }

   def validate_password
  	reg = /(?=.*\d)(?=.*([A-Z])).{4,}/

	if not reg.match(password)
           errors.add(:password, "must contain 4 characters, including one number and one capitalized letter.") 
        end
   end

   def favorite_beer
      return nil if ratings.empty?   # palautetaan nil jos reittauksia ei ole
      #ratings.first.beer             palataan ensimmaiseen reittaukseen liittyvä olut
      #sortataan scoren mukaan oluet, alin eli korkein score -> mieliolut
      #ratings.sort_by{ |r| r.score }.last.beer
      #voidaan tehdä myös:
      #ratings.sort_by(&:score).last.beer
      #sortataan tietokantakyselyssä, käänteinen järjestys ja ensimmäinen (limit(1)) ja first.beer
      ratings.order(score: :desc).limit(1).first.beer
   end
  
   def favorite_style
    return nil if ratings.empty?

    rated = ratings.map{ |r| r.beer.style }.uniq
    rated.sort_by { |style| -rating_of_style(style) }.first
  end

  def favorite_brewery
    return nil if ratings.empty?

    rated = ratings.map{ |r| r.beer.brewery }.uniq
    rated.sort_by { |brewery| -rating_of_brewery(brewery) }.first
  end

  private

  def rating_of_style(style)
    ratings_of = ratings.select{ |r| r.beer.style==style }
    ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
  end

  def rating_of_brewery(brewery)
    ratings_of = ratings.select{ |r| r.beer.brewery==brewery }
    ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
  end

   
end
