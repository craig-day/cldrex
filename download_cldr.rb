require 'net/http'
require 'json'

uri = URI('http://i18ndata.appspot.com/cldr/tags/approved/main')
res = Net::HTTP.get_response(uri)

locales = JSON.parse(res.body)

locales.keys.each do |locale|
  puts "Downloading #{locale}"
  uri = URI("http://i18ndata.appspot.com/cldr/tags/approved/main/#{locale}?depth=-1")
  res = Net::HTTP.get_response(uri)

  body = JSON.parse(res.body)
  num_sys = "symbols-numberSystem-#{body['numbers']['defaultNumberingSystem']}"

  wanted_json = {
    "dates" => body['dates'],
    "localeDisplayNames" => {
      "languages" => body['localeDisplayNames']['languages']
    },
    "numbers" => {
      "percentFormats" => body['numbers']['percentFormats'],
      "defaultNumberingSystem" => body['numbers']['defaultNumberingSystem'],
      "#{num_sys}" => body['numbers'][num_sys],
      "currencies" => body['numbers']['currencies'],
      "decimalFormats" => body['numbers']['decimalFormats']
    }
  }

  File.open("./priv/data/common/main_json/#{locale}.json", 'w') do |f|
    f.puts JSON.dump(wanted_json)
  end
end

