require 'faraday'
require 'json'
class QuoteGenerator
  API_KEY = ENV['QUOTE_API_KEY']
  QUOTE_API_URL = ENV['QUOTE_API_URL']
  def get_quote
    con = Faraday.new(url: QUOTE_API_URL) do |faraday|
      faraday.headers['X-Api-Key'] = API_KEY

      faraday.headers['Content-Type'] = 'application/json'
    end

    res = con.get do |req|

    end
    
    if res.success?
      puts "Gathering Quote"
      p JSON.parse(res.body).first
      return res.body
    else
      puts "Request failed with status #{res.status}: #{res.body}"
    end
  end
end