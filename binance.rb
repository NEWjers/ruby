require 'open-uri'

url = 'https://www.binance.com/en/markets'
html = URI.open(url)

require 'nokogiri'

doc = Nokogiri::HTML(html)

tradeItems = doc.xpath('//div[@id="market_trade_list_item"]')
  
tradeItems.each do |currency|
  columns = currency.xpath('./div')
  
  data = columns.first(2).map{ |column|
    column.xpath('./div/div')
      .map{ |element| element.text}
      .join
      .gsub(/\s+/, "")
  }.join(',')
  
  open('data.csv', 'a') { |f| 
    f.puts data
  }
end

