require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    #should be as setted
    expect(user.username).to eq("Pekka")
    #user.username.should == "Pekka"
  end
  
  it "is not saved without a password" do
    user = User.create username:"Pekka"

    #should be invalid
    #expect(user.valid?).to be(false)
    expect(user).not_to be_valid
    #should not be any users
    expect(User.count).to eq(0)
  end

  it "or with a password too short"  do
    user = User.create username:"Pekka", password:"Se1", password_confirmation:"Se1"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
 end 

  it "or a with password containing only letters" do
    user = User.create username:"Pekka", password:"Seeee", password_confirmation:"Seeee"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) } 

     it "is saved" do
    
      #should be valid
      expect(user.valid?).to be(true)
      #expect(user).to be_valid
      #should be one user
      expect(User.count).to eq(1)
     end

     it "and two ratings, has the correct average rating" do
    
      #rating = Rating.new score:10
      #rating2 = Rating.new score:20

      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
     end  
  end
  
  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 20, 15, 7, 9)
      best = create_beer_with_rating(user, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  #describe "favorite style" do
  #  let(:user){FactoryGirl.create(:user) }

  #  it "has method for determining one" do
  #    expect(user).to respond_to(:favorite_style)
  #  end

  #  it "without ratings does not have one" do
  #    expect(user.favorite_style).to eq(nil)
  #  end

  #  it "is the only rated beer's style if only one rating" do
  #    beer = create_beer_with_rating(user, 10)

  #    expect(user.favorite_style).to eq(beer.style)
  #  end

    #it "is the one style with highest rating if several styles rated" do
    #  create_beers_with_ratings(user, 10, 20, 15, 7, 9)
    #  best = create_beer_with_rating(user, 25)
    #
    #  expect(user.favorite_style).to eq(best.style)
    # end
  #end

end # describe User

def create_beers_with_ratings(user, *scores)
  scores.each do |score|
    create_beer_with_rating user, score
  end
end

def create_beer_with_rating(user, score)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score,  beer:beer, user:user)
  beer
end
