class Membership < ActiveRecord::Base
   belongs_to :beer_club
   belongs_to :user

   #scope :confirmed, -> { where confirmed:true }
   #scope :not_confirmed, -> { where confirmed:[nil,false] } 
  
   validates :beer_club_id, presence: true   
   validates :user_id, presence: true
   validates_uniqueness_of :beer_club_id, scope: :user_id
   
end
