require_relative "onebus/my_crawler.rb"
require_relative "onebus/my_data_parser.rb"
require 'json'


module OneBus
	# find can be treated as main function. 
	# For crawling websites to get specific details

	def self.find(from, going_to, departure_at)
	    begin
      source     = crawl(from, going_to, departure_at)
      
      DataParser.giveResults(source, from, going_to)
      rescue Exception => e
        puts e.message
      end
     
    end
    def self.crawl(from, going_to, departure_at)
    	params = {
      	from:          from,
      	going_to:      going_to,
      	departure_at:  departure_at,
    	}
    	Crawler.crawl(params)
  	end
end

OneBus.find(00,00,DateTime.new(2014,4))

  
