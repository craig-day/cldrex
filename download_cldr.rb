require 'net/http'
require 'json'

uri = URI('http://i18ndata.appspot.com/cldr/tags/approved/main')
res = Net::HTTP.get_response(uri)

locales = JSON.parse(res.body)

locales.keys.each do |locale|
  puts "Downloading #{locale}"
  uri = URI("http://i18ndata.appspot.com/cldr/tags/approved/main/#{locale}?depth=-1")
  res = Net::HTTP.get_response(uri)

  File.open("./priv/data/common/main_json/#{locale}.json", 'w') do |f|
    f.puts res.body
  end
end

