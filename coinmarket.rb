require 'open-uri'

class BinanceReader
  def initialize(url)
    @url = url
  end

  def getDocument
    # url = 'https://www.binance.com/en/markets'
    html = URI.open(@url)
    require 'nokogiri'
    doc = Nokogiri::HTML(html)
    return doc
  end

  def processDoc
    doc = getDocument
    coins = doc.css('table tbody tr.cmc-table-row')
  
    coins.each do |coin|
      name = coin.css('td.cmc-table__cell.cmc-table__cell--sticky.cmc-table__cell--sortable.cmc-table__cell--left.cmc-table__cell--sort-by__name div a[3]').inner_html
      short = coin.css('td.cmc-table__cell.cmc-table__cell--sortable.cmc-table__cell--left.cmc-table__cell--hide-sm.cmc-table__cell--sort-by__symbol div').inner_html
      price = coin.css('td.cmc-table__cell.cmc-table__cell--sortable.cmc-table__cell--right.cmc-table__cell--sort-by__price div a span').inner_html
    
      unless name == ""  
        open('coins.csv', 'a') { |f| 
          f.puts name + ", " + short + ", " + price + ";"
        } 
      end
    end
  end
end

reader = BinanceReader.new('https://coinmarketcap.com/all/views/all/')
reader.processDoc


