require_relative "../onebus/my_crawler.rb"
require_relative "../onebus/my_data_parser.rb"
require 'json'

describe OneBus::DataParser  do
  before(:all) do
    #test the boundary cases
    @params1 = {
          from:         69,
          going_to:     64,
          departure_at: DateTime.new(2014,4,2),
      }
    @source1=OneBus::Crawler.crawl(@params1)
    
    @params2 = {
          from:         00,
          going_to:     00,
          departure_at: DateTime.new(2014,5,8),
      }
    @source2=OneBus::Crawler.crawl(@params2)

    #test the main functionality part
    @params3 = {
          from:         69,
          going_to:     65,
          departure_at: DateTime.new(2014,4,5),
      }
    @source3=OneBus::Crawler.crawl(@params3)
    
    @source_hash3= JSON.parse(@source3)

  
  end


  it "should return uncatched throw" do
    expect{OneBus::DataParser.giveResults(@source1,@params1[:from],@params1[:going_to])}.to raise_error 
  end
  
  it "should return uncatched throw" do
    expect{OneBus::DataParser.giveResults(@source2,@params2[:from],@params2[:going_to])}.to raise_error 
  end

  it "should return proper cities names" do
    source_city, destination_city = OneBus::DataParser.city(@source_hash3,@params3[:from],@params3[:going_to])

    source_city.should eql "Düsseldorf"
    destination_city.should eql "Magdeburg"

  end

  it "should return date time objects of departure date" do
    source_station_date = 
          OneBus::DataParser.get_time_table(@source_hash3["payload"]["itemList"][0]["ConnectionSectionList"][0],
                            "DayFrom",
                            "TimeofdayFrom")
    @params3[:departure_at].to_date.should eql source_station_date.to_date

    


  end

  
end