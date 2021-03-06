require 'rails_helper'

describe "BeermappingApi" do
 describe "in case of cache miss" do

    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do
      canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

      places = BeermappingApi.places_in("espoo")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Gallows Bird")
      expect(place.street).to eq("Merituulentie 30")
    end

  end

  describe "in case of cache hit" do

    it "When one entry in cache, it is returned" do
      canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

      # ensure that data found in cache
      BeermappingApi.places_in("espoo")

      places = BeermappingApi.places_in("espoo")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("O'Connell's Irish Bar")
      expect(place.street).to eq("Rautatienkatu 24")
    end
  end




  it "When HTTP GET returns one entry, it is parsed and returned" do

    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("espoo")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("Gallows Bird")
    expect(place.street).to eq("Merituulentie 30")
  end

  it "when HTTP GET does not return any entry, it returns empty array" do

    canned_answer = <<-END_OF_STRING
<?xml version="1.0" encoding="UTF-8"?><bmp-locations><location><id nil="true"/><name nil="true"/><status nil="true"/><reviewlink nil="true"/><proxylink nil="true"/><blogmap nil="true"/><street nil="true"/><city nil="true"/><state nil="true"/><zip nil="true"/><country nil="true"/><phone nil="true"/><overall nil="true"/><imagecount nil="true"/></location></bmp-locations>
    END_OF_STRING

    stub_request(:get, /.*kolari/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("kolari")

    expect(places.size).to eq(0)
  end

  it "when HTTP GET returns multiple entries, all of them are parsed and returned" do

     canned_answer = <<-END_OF_STRING
<?xml version="1.0" encoding="UTF-8"?>
<bmp-locations>
  <location type="array">
    <location>
      <id>18098</id>
      <name>Panimoravintola Beer Hunter's</name>
      <status>Beer Bar</status>
      <reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=18098</reviewlink>
      <proxylink>http://beermapping.com/maps/proxymaps.php?locid=18098&amp;d=5</proxylink>
      <blogmap>http://beermapping.com/maps/blogproxy.php?locid=18098&amp;d=1&amp;type=norm</blogmap>
      <street>Antinkatu 11</street>
      <city>Pori</city>
      <state nil="true"/>
      <zip>28100</zip>
      <country>Finland</country>
      <phone>+358 2 6415599</phone>
      <overall>0</overall>
      <imagecount>0</imagecount>
    </location>
    <location>
      <id>18149</id>
      <name>Ravintola Kirjakauppa</name>
      <status>Beer Bar</status>
      <reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=18149</reviewlink>
      <proxylink>http://beermapping.com/maps/proxymaps.php?locid=18149&amp;d=5</proxylink>
      <blogmap>http://beermapping.com/maps/blogproxy.php?locid=18149&amp;d=1&amp;type=norm</blogmap>
      <street>Antinkatu 10</street>
      <city>Pori</city>
      <state nil="true"/>
      <zip>29100</zip>
      <country>Finland</country>
      <phone>045 358 77 93</phone>
      <overall>0</overall>
      <imagecount>0</imagecount>
    </location>
    <location>
      <id>18854</id>
      <name>Panimoravintola Beer Hunter's</name>
      <status>Brewery</status>
      <reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=18854</reviewlink>
      <proxylink>http://beermapping.com/maps/proxymaps.php?locid=18854&amp;d=5</proxylink>
      <blogmap>http://beermapping.com/maps/blogproxy.php?locid=18854&amp;d=1&amp;type=norm</blogmap>
      <street>Antinkatu 11</street>
      <city>Pori</city>
      <state nil="true"/>
      <zip>28100</zip>
      <country>Finland</country>
      <phone>+358 2 641 55 99</phone>
      <overall>0</overall>
      <imagecount>0</imagecount>
    </location>
    <location>
      <id>18862</id>
      <name>Ruosniemen Panimo</name>
      <status>Brewery</status>
      <reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=18862</reviewlink>
      <proxylink>http://beermapping.com/maps/proxymaps.php?locid=18862&amp;d=5</proxylink>
      <blogmap>http://beermapping.com/maps/blogproxy.php?locid=18862&amp;d=1&amp;type=norm</blogmap>
      <street>Eetunkuja 6</street>
      <city>Pori</city>
      <state nil="true"/>
      <zip>28220</zip>
      <country>Finland</country>
      <phone nil="true"/>
      <overall>0</overall>
      <imagecount>0</imagecount>
    </location>
    <location>
      <id>18907</id>
      <name>Radius Brewing Company</name>
      <status>Brewpub</status>
      <reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=18907</reviewlink>
      <proxylink>http://beermapping.com/maps/proxymaps.php?locid=18907&amp;d=5</proxylink>
      <blogmap>http://beermapping.com/maps/blogproxy.php?locid=18907&amp;d=1&amp;type=norm</blogmap>
      <street>610 Merchant Street</street>
      <city>Emporia</city>
      <state>KS</state>
      <zip>66801</zip>
      <country>United States</country>
      <phone>(620) 208-4677</phone>
      <overall>81.66665</overall>
      <imagecount>0</imagecount>
    </location>
  </location>
</bmp-locations>
 END_OF_STRING

    stub_request(:get, /.*pori/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("pori")

    expect(places.size).to eq(5)
    place1 = places.first
    place2 = places.last
    expect(place1.name).to eq("Panimoravintola Beer Hunter's")
    expect(place2.name).to eq("Radius Brewing Company")
  end
end
