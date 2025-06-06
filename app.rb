require "sinatra"
require "sinatra/reloader"
require "http"
require "dotenv/load"

get("/") do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EX_RATE_KEY")}"
  @raw_response = HTTP.get(api_url)
  @raw_string = @raw_response.to_s
  @parsed_data = JSON.parse(@raw_string)

  @currencies = @parsed_data.fetch("currencies").keys #array of symbols like AED, AFN, etc
  erb(:homepage)
end

get("/:first_symbol") do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EX_RATE_KEY")}"
  @raw_response = HTTP.get(api_url)
  @raw_string = @raw_response.to_s
  @parsed_data = JSON.parse(@raw_string)

  @currencies = @parsed_data.fetch("currencies").keys #array of symbols like AED, AFN, etc
  @symbol_one = params.fetch("first_symbol")
  erb(:step_one)
end

get("/:first_symbol/:second_symbol") do
  @from = params.fetch("first_symbol")
  @to = params.fetch("second_symbol")

  @url = "https://api.exchangerate.host/convert?access_key=#{ENV.fetch("EX_RATE_KEY").chomp}&from=#{@from}&to=#{@to}&amount=1"
  @raw_response = HTTP.get(@url)
  @string_response = @raw_response.to_s
  @parsed_response = JSON.parse(@string_response)

  @amount = @parsed_response.fetch("result")

  erb(:step_two)

end
