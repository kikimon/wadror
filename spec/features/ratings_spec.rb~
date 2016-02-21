require 'rails_helper'

include Helpers


describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:brewery2) { FactoryGirl.create :brewery, name:"Saimaan juomatehdas" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:beer3) { FactoryGirl.create :beer, name:"Keisari 66", brewery:brewery2 }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user2 }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "when given, is saved and shown in ratings page with a count" do
     rating1 = Rating.create score:"27", beer: beer1, user: user
     rating2 = Rating.create score:"30", beer: beer2, user: user
    
     visit ratings_path
     expect(page).to have_content "Number of ratings: #{Rating.count}"
     expect(page).to have_content rating1.user.username
     expect(page).to have_content rating2.beer.name  
  end

  it "when given, is shown in the specific user's page" do
     rating1 = Rating.create score:"27", beer: beer1, user: user
     rating2 = Rating.create score:"30", beer: beer2, user: user
     rating3 = Rating.create score:"15", beer: beer3, user: user2
     
     visit user_path(user)
     expect(page).to have_content rating1.beer.name
     expect(page).to have_content rating2.beer.name
     expect(page).to have_no_content rating3.beer.name
     expect(page).to have_no_content rating3.score
     #save_and_open_page 
  end

  it "when user deletes given rating, rating is removed from database" do
     rating1 = Rating.create score:"27", beer: beer1, user: user
     rating2 = Rating.create score:"30", beer: beer2, user: user
     
     visit user_path(user)
     expect(user.ratings.count).to eq(2)  
     find(:xpath, "//a[@href='/ratings/1']").click
     expect(user.ratings.count).to eq(1) 
     #save_and_open_page 
  end
end
