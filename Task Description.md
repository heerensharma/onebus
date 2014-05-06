## Brief description of bots

A bot is a module that has a `.find` method that accepts arguments `from`, `going_to`, and `departure_at`.
It gathers information from the site and returns them in the format below.

## A note about `.find` arguments

`from` and `going_to` will be **exactly** what you need for the site.
They can be a string, and array or what ever you need to fill out a form to submit a search.
`.find` can assume it will be given the proper arguments.
`departure_at` will be a Ruby DateTime object.

## Your task

We would like you to build a bot from scratch which crawl and parse data for http://www.onebus.de When you are done, it should behave in the following way:

`DeOnebus.find(<from>, <going_to>, <departure_at>)` should return results in this format:

```ruby
[
  {
    "departure_station"   => station_name,
    "departs_at"          => DateTime,
    "arrival_station"     => station_name,
    "arrives_at"          => DateTime,
    "duration_in_minutes" => number_of_minutes
    "service_agencies"    => ["DeOnebus"],
    "changeovers"         => changeovers,
    "vehicle"             => "Bus",
    "extra"               => { },
    "fares"               => [ { "name"           => "economy",
                                 "price_in_cents" => price,
                                 "currency"       => "EUR",
                                 "comfort_class"  => 2,
                                 "booking_agency" => "DeAldiFernbus" },
                               #...
                             ]
  },
  #...
]
```


