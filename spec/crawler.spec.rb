require_relative '../onebus/my_crawler.rb'
require "open-uri"


describe OneBus::Crawler do 


  it "successfully should successfully create url" do
    params = {
          from:         69,
          going_to:     64,
          departure_at: DateTime.new(2014,4,4),
      }

      test_string = "https://www.tixys.com/onebus?from=69&to=64&day=2014-04-04&st="
      OneBus::Crawler.build_url(params).should eql test_string 
    end
end