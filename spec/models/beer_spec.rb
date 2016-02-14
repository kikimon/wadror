require 'rails_helper'

RSpec.describe Beer, type: :model do

  it "is saved when it has a name and a style set correctly" do
    beer = Beer.create name:"Keisari 66", style:"Lager"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "and is not saved without a name" do
     beer = Beer.create style:"Lager"
     expect(beer).to be_invalid
     expect(Beer.count).to eq(0)
  end

  it "and a style" do
     beer = Beer.create name:"Keisari 66"
     expect(beer).to be_invalid
     expect(Beer.count).to eq(0)
  end
end
