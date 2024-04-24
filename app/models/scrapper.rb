require 'nokogiri'
require 'open-uri'

class Scrapper
  def scrape_data
    lower_range = 200000
    upper_range = 400000
    # Fetch and parse HTML document
    products = []
    28.times.each do |i|
      doc = Nokogiri::HTML(URI.open("https://www.pakwheels.com/used-cars/search/-/pr_#{lower_range}_#{upper_range}/?page=#{i+1}"))
  
      # puts doc
      # Search for nodes by css
      all_products_container = doc.css('.search-page-new div.search-listing')
      all_products_container.each do |product|
        title = product.css('ul.search-results li.classified-listing div.search-title-row a h3').text
        price = product.css('ul.search-results li.classified-listing div.search-title-row .price-details span').text
        single_product = [title, price]
        p single_product
        products << single_product
      end
    end
    # products.each do |product|
    #   puts "#{product[0]} - #{product[1]}"
    # end
  end
end

Scrapper.new.scrape_data