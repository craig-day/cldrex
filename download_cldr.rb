require 'net/http'
require 'json'

uri = URI('http://i18ndata.appspot.com/cldr/tags/approved/main')
res = Net::HTTP.get_response(uri)

locales = JSON.parse(res.body)

locales.keys.each do |locale|
  uri = URI("http://i18ndata.appspot.com/cldr/tags/approved/main/#{locale}?depth=-1")
  res = Net::HTTP.get_response(uri)
  locales[locale] = JSON.parse(res.body)
end

File.open('./priv/data/common/main.json', 'w') { |f| f.puts(JSON.dump(locales)) }
