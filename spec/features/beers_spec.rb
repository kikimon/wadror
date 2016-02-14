require 'rails_helper'

include Helpers


describe "Beers page" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Saimaan juomatehdas" }

  it "It should be able to add beer" do
    visit new_beer_path
    fill_in('beer[name]', with:'Keisari 66')
    select('Lager', from:'beer[style]')
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
    expect(current_path).to eq(beers_path)
    #save_and_open_page
  end

  it "It should not let beer without a name to be added" do
    visit new_beer_path
    select('Lager', from:'beer[style]')
    click_button "Create Beer"

    expect(Beer.count).to eq(0)
    expect(page).to have_content 'Name can\'t be blank'   
  end
end
