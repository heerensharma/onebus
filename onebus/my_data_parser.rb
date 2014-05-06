require "json"

module OneBus

  class DataParser
      def self.giveResults(source, from, going_to)
        results= Array.new
        source_hash = JSON.parse(source)
        #initial boundary conditions to check whether it is 
        #needed to parse in the first place e.g. in case of errors, invalid requests
        if source_hash["success"] == 'false'
          throw "This request is not valid"
        end
        if source_hash['entityList'].nil? == true or source_hash['entityList'].empty? == true
          throw "No results to show here"
        end
        if source_hash["payload"]["itemList"][0]["tagList"][0] == "deadlineExceeded"
          throw "May be you are sending request for a past date or very far far future date"
        end

        source_city, destination_city = city(source_hash,from, going_to)

        #some heuristical data settings
        passenger_types = {'1' => "Adult",'65'=> "Bicycle",'45'=> "Child"}

        for data in source_hash["payload"]["itemList"]
          connection_entry={}
          connection_entry["departure_station"]=source_city
          connection_entry["departs_at"]=get_time_table(data["ConnectionSectionList"][0],"DayFrom","TimeofdayFrom")
          connection_entry["arrival_station"]=destination_city
          connection_entry["arrives_at"]=get_time_table(data["ConnectionSectionList"][0],"DayTo","TimeofdayTo")
          connection_entry["duration_in_minutes"]=data["duration"]
          connection_entry["service_agencies"]=["DeOneBus"]
          connection_entry["changeovers"]=[]
          connection_entry["vehicle"]= "Bus"  
          connection_entry["extra"]={}
          connection_entry["fares"]=get_fares(data["CargotypePricesList"],passenger_types)
          results << connection_entry
        end 
        puts results
        results
      end



       

      #getting the name of the cities respective to their station codes

      def self.city(source_hash,from, going_to)
        return city_name(source_hash["entityList"],from), city_name(source_hash["entityList"],going_to)
      end

      def self.city_name(input_hash,city_code)
        input_hash["Station:#{city_code}"]["name"].to_s.match(/\](.*?)\[/m)[1]
      end

      #getting the time table of scheduled bus
      def self.get_time_table(input_hash,arg1,arg2)
        DateTime.new(
                input_hash["Period"][arg1]['y'],
                input_hash["Period"][arg1]['m'],  
                input_hash["Period"][arg1]['d'],
                input_hash["Period"][arg2]['h'],
                input_hash["Period"][arg2]['m'],
                0,
              )
      end
        
      #getting fare details for a specific connection

      def self.get_fares(input_hash,passenger_types)
        return_list = Array.new
        for passenger in input_hash
          temp_hash={}
          temp_hash["passenger_type"]=passenger_types[passenger["Cargotype"].match(/\#e\#Cargotype\:(.*)/)[1]]
          temp_hash["price_in_cents"]=((passenger["Prices"]['discount'].to_f)*100).to_i
          temp_hash["currency"]="EUR"
          temp_hash["booking_agency"]="DeOneBus"
          return_list << temp_hash
        end 
        return_list
      end

  end
end