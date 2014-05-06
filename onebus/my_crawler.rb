require "open-uri"
require "typhoeus"
# require "faraday"
require "json"
require 'net/https'
require 'faraday_middleware'
require 'oj'


module OneBus
  class Crawler

    BASE_URL = 'https://www.tixys.com/onebus'.freeze

    
    	attr_reader :request
    	attr_reader :response
    	attr_reader :cookie
    	attr_reader :request_city_name
    	attr_reader :get_city_name 

      def self.crawl(params)
        begin
        url         = URI.encode build_url(params)
        complete_uri         = URI.parse(url)

       	#this first request call is to get basic initial parameters, like 
       	#cookie value, site id, various tokens informations, etc. 

       	@cookie = Typhoeus.get(complete_uri, followlocation: true)

      	#required to take 'Site parameter' and 'X-token'
      	#they are necessary to throw with the request json header

      	# x_token = @cookie.body.to_s.match(/, token : "(.*?)" };/m)[1]
      	# site_id = @cookie.body.to_s.match(/ {"site":(.*?),/m)[1]
      	
      	#body message for our request call to json endpoint to fetch the details about travel routes
      	#available for inputted parameters.

      	request_body_msg = {"Site"=> @cookie.body.to_s.match(/ {"site":(.*?),/m)[1].to_i,
      					"StationFrom"=> params[:from].to_i,
      					"StationTo"=> params[:going_to].to_i,
      					"Period"=>{"DayFrom"=>{"d"=> params[:departure_at].day,"m"=> params[:departure_at].month,"y"=> params[:departure_at].year},
      								"TimeofdayFrom"=>{"h"=>0,"m"=>0},
      								"DayTo"=>{"d"=> params[:departure_at].day,"m"=> params[:departure_at].month,"y"=> params[:departure_at].year},
      								"TimeofdayTo"=>{"h"=>23,"m"=>59}},
      					"CargotypeCountList"=>[]}
      	
      	
      	#header message for request call for json endpoint
      	request_header = {
							'Cookie'=> @cookie.headers['Set-Cookie'].split('; ')[0], 
 							'Origin' => 'https://www.tixys.com', 
							'X-Token' => @cookie.body.to_s.match(/, token : "(.*?)" };/m)[1], 
							'Accept-Language' => 'en-US,en;q=0.8', 
							'User-Agent' => 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.152 Safari/537.36', 
							'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8', 
							'Accept' => 'application/json, text/javascript, */*; q=0.01', 
							'Referer' => complete_uri, 
							'X-Requested-With' => 'XMLHttpRequest', 
							'Connection' => 'keep-alive',}

		

      	#this points towards the search results for the given input parameters
      	json_endpoint_Connection_uri = "https://www.tixys.com/api/v1/ConnectionSearch"

      	#request to call json endpoint named ConnectionSearch to get the details about available options between A to B

      	@request = Typhoeus::Request.new(json_endpoint_Connection_uri,
      										method: :post,
      										body: {
						      						request: Oj.dump(request_body_msg),
      												locale: 'en_GB'},
      							     		headers: request_header,
										)

      	#As the name of cities are in numbers, so this uri is used to map city names to these numbers					
      	json_endpoint_Selection_uri= "https://www.tixys.com/api/v1/StationSearch"

      	#request body message to get city names mapping with respective integers as a list and further process them
      	request_city_name_body_msg = {	"Site" => @cookie.body.to_s.match(/ {"site":(.*?),/m)[1].to_i,
										"name" => nil,
										"onlyStartStations" => true,
										"onlyEndStations" => nil,
										"StationFrom" => nil,
										"StationTo" => nil,
										"Maparea" => nil,
										"statusList" => [1],
										"orderBy" => "name"}



     	#request call to get city names for the respective input parametric integers
      	@request_city_name = Typhoeus::Request.new(json_endpoint_Selection_uri,
      										method: :post,
      										body: {
						      						request: Oj.dump(request_city_name_body_msg),
      												locale: 'en_GB'},
      							     		headers: request_header,
										)

  
      	@response  = @request.run
      	@get_city_name = @request_city_name.run
      	# binding.pry

      	return @response.body
      rescue Exception => e
        throw e.message
      end

      end


      private

      def self.build_url(params)
      	#source and destination are represented as numbers
        from         = params[:from]
        going_to     = params[:going_to]
        departure_at = params[:departure_at].strftime('%Y-%m-%d')

        url  = BASE_URL.dup
        url << "?from=#{from}"
        url << "&to=#{going_to}"
        url << "&day=#{departure_at}"
        url << "&st=" 
      end

  end
 
end
