class Membership < ActiveRecord::Base
   belongs_to :beer_club
   belongs_to :user
   
   validates :beer_club_id, presence: true   
   validates :user_id, presence: true
   validates_uniqueness_of :beer_club_id, scope: :user_id
   
end
